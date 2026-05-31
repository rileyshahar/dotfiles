import { environment } from "@raycast/api";
import { spawn } from "child_process";
import fs from "fs";
import os from "os";
import path from "path";

export type SinkMode = "all" | "each";

export type ActionSpec = {
  title: string;
  exec: string;
  shortcut?: { modifiers: string[]; key: string };
  sink_mode?: SinkMode;
};

export type DropdownSpec = {
  tooltip?: string;
  items: { title: string; value: string }[];
};

export type Config = {
  placeholder: string;
  sink_mode: SinkMode;
  source_format: "lines" | "json";
  item_type: "plain" | "file";
  primary_title?: string;
  dropdown?: DropdownSpec;
  actions: ActionSpec[];
  // When true, items acted on are remembered and floated to the top of the
  // browse list on later opens (builtin-filter commands only).
  recents?: boolean;
};

export type Item = {
  value: string;
  title: string;
  subtitle?: string;
  icon?: string;
};

// Commands the framework runs (source/filter/sink/custom actions) live in the
// user's nix/homebrew install, which Raycast's spawned env doesn't have on PATH.
const PATH_PREFIX = [
  path.join(os.homedir(), ".nix-profile/bin"),
  "/run/current-system/sw/bin",
  "/etc/profiles/per-user/" + os.userInfo().username + "/bin",
  "/opt/homebrew/bin",
  "/usr/local/bin",
].join(":");

// Raycast spawns the extension with SHELL=/bin/sh, which anything we launch
// (e.g. nvim's :terminal) would inherit. Resolve the login shell once so spawned
// processes match it. Falls back to process.env.SHELL when fish isn't installed.
const LOGIN_SHELL = ((): string | undefined => {
  for (const dir of PATH_PREFIX.split(":")) {
    const candidate = path.join(dir, "fish");
    try {
      if (fs.statSync(candidate).isFile()) return candidate;
    } catch {
      // not here; keep looking
    }
  }
  return process.env.SHELL;
})();

function spawnEnv(extra?: Record<string, string>): NodeJS.ProcessEnv {
  return {
    ...process.env,
    ...(LOGIN_SHELL ? { SHELL: LOGIN_SHELL } : {}),
    ...extra,
    PATH: `${PATH_PREFIX}:${process.env.PATH ?? ""}`,
  };
}

export function commandDir(command: string): string {
  return path.join(environment.assetsPath, "commands", command);
}

export function loadConfig(command: string): Config {
  const raw = fs.readFileSync(path.join(commandDir(command), "config.json"), "utf8");
  const parsed = JSON.parse(raw) as Partial<Config>;
  return {
    placeholder: parsed.placeholder ?? "Filter…",
    sink_mode: parsed.sink_mode ?? "all",
    source_format: parsed.source_format ?? "lines",
    item_type: parsed.item_type ?? "plain",
    primary_title: parsed.primary_title,
    dropdown: parsed.dropdown,
    actions: parsed.actions ?? [],
    recents: parsed.recents ?? false,
  };
}

export function parseItems(lines: string[], format: Config["source_format"], itemType: Config["item_type"]): Item[] {
  return lines.map((line) => {
    if (format === "json") {
      try {
        const obj = JSON.parse(line) as Partial<Item>;
        const value = obj.value ?? obj.title ?? line;
        return { value, title: obj.title ?? value, subtitle: obj.subtitle, icon: obj.icon };
      } catch {
        return { value: line, title: line };
      }
    }
    if (itemType === "file") {
      const home = os.homedir();
      return {
        value: line,
        title: line.startsWith(home) ? line.replace(home, "~") : line,
        subtitle: path.basename(line),
      };
    }
    return { value: line, title: line };
  });
}

// Run a command-dir executable, capturing stdout. Used for `source`.
function run(
  exe: string,
  args: string[],
  opts: { env?: Record<string, string>; signal?: AbortSignal; stdinFile?: string } = {},
): Promise<{ code: number; stdout: string; stderr: string }> {
  return new Promise((resolve, reject) => {
    const stdin = opts.stdinFile ? fs.openSync(opts.stdinFile, "r") : "ignore";
    const child = spawn(exe, args, {
      stdio: [stdin, "pipe", "pipe"],
      env: spawnEnv(opts.env),
      signal: opts.signal,
    });
    let stdout = "";
    let stderr = "";
    child.stdout?.on("data", (d) => (stdout += d.toString()));
    child.stderr?.on("data", (d) => (stderr += d.toString()));
    child.on("error", reject);
    child.on("close", (code) => {
      if (typeof stdin === "number") fs.closeSync(stdin);
      resolve({ code: code ?? 0, stdout, stderr });
    });
  });
}

// Run `source` and return its lines directly.
export async function runSourceLines(command: string, dropdownValue: string): Promise<string[]> {
  const { code, stdout, stderr } = await run(path.join(commandDir(command), "source"), [], {
    env: { PICKER_DROPDOWN: dropdownValue },
  });
  if (code !== 0) throw new Error(stderr.trim() || `source exited ${code}`);
  return stdout.split("\n").filter((l) => l.length > 0);
}

// Run a sink/custom-action executable against the selected targets.
export async function runTargets(exe: string, targets: string[], mode: SinkMode): Promise<void> {
  if (mode === "each") {
    const results = await Promise.all(targets.map((t) => run(exe, [t])));
    const failed = results.find((r) => r.code !== 0);
    if (failed) throw new Error(failed.stderr.trim() || `exited ${failed.code}`);
    return;
  }
  await new Promise<void>((resolve, reject) => {
    const child = spawn(exe, [], { stdio: ["pipe", "ignore", "pipe"], env: spawnEnv() });
    let stderr = "";
    child.stderr?.on("data", (d) => (stderr += d.toString()));
    child.on("error", reject);
    child.on("close", (code) => (code === 0 ? resolve() : reject(new Error(stderr.trim() || `exited ${code}`))));
    child.stdin?.end(targets.join("\n") + "\n");
  });
}
