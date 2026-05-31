import { environment } from "@raycast/api";
import { spawn } from "child_process";
import { createHash } from "crypto";
import fs from "fs";
import afs from "fs/promises";
import os from "os";
import path from "path";
import readline from "readline";

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
  filter: "builtin" | "stream";
  item_type: "plain" | "file";
  primary_title?: string;
  dropdown?: DropdownSpec;
  actions: ActionSpec[];
};

export type Item = {
  value: string;
  title: string;
  subtitle?: string;
  icon?: string;
};

export const MAX_RESULTS = 1000;

// Reuse a previously-written source index for this long before re-running
// `source`. Mirrors fuzzy-file-search caching fd output across opens so the
// list appears instantly on repeat opens instead of re-walking the tree.
const SOURCE_TTL_MS = 5 * 60 * 1000;

// Commands the framework runs (source/filter/sink/custom actions) live in the
// user's nix/homebrew install, which Raycast's spawned env doesn't have on PATH.
const PATH_PREFIX = [
  path.join(os.homedir(), ".nix-profile/bin"),
  "/run/current-system/sw/bin",
  "/etc/profiles/per-user/" + os.userInfo().username + "/bin",
  "/opt/homebrew/bin",
  "/usr/local/bin",
].join(":");

function spawnEnv(extra?: Record<string, string>): NodeJS.ProcessEnv {
  return {
    ...process.env,
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
    filter: parsed.filter ?? "builtin",
    item_type: parsed.item_type ?? "plain",
    primary_title: parsed.primary_title,
    dropdown: parsed.dropdown,
    actions: parsed.actions ?? [],
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

// Run `source`, writing its full output to a per-command/per-dropdown index
// file so a filter can read it repeatedly without re-running source. While the
// source streams, `onBatch` receives the first MAX_RESULTS lines so the UI can
// paint a browse view as files arrive instead of waiting for the full walk.
// A fresh cached index is returned immediately without re-running source.
export async function runSourceToFile(
  command: string,
  dropdownValue: string,
  onBatch?: (lines: string[]) => void,
): Promise<string> {
  const key = createHash("sha1").update(`${command}\n${dropdownValue}`).digest("hex");
  const out = path.join(environment.supportPath, `source-${key}.txt`);
  try {
    const stat = await afs.stat(out);
    if (Date.now() - stat.mtimeMs < SOURCE_TTL_MS) return out;
  } catch {
    // no cached index yet; fall through and build one
  }
  await afs.mkdir(environment.supportPath, { recursive: true });
  const tmp = `${out}.${Date.now()}.tmp`;
  await new Promise<void>((resolve, reject) => {
    const ws = fs.createWriteStream(tmp);
    const child = spawn(path.join(commandDir(command), "source"), [], {
      stdio: ["ignore", "pipe", "pipe"],
      env: spawnEnv({ PICKER_DROPDOWN: dropdownValue }),
    });
    const rl = readline.createInterface({ input: child.stdout! });
    let stderr = "";
    let batch: string[] = [];
    let emitted = 0;
    rl.on("line", (line) => {
      ws.write(line + "\n");
      if (onBatch && line.length > 0 && emitted < MAX_RESULTS) {
        batch.push(line);
        emitted++;
        if (batch.length >= 100) {
          onBatch(batch);
          batch = [];
        }
      }
    });
    child.stderr?.on("data", (d) => (stderr += d.toString()));
    child.on("error", reject);
    child.on("close", (code) => {
      if (onBatch && batch.length > 0) onBatch(batch);
      ws.end(() => (code === 0 ? resolve() : reject(new Error(stderr.trim() || `source exited ${code}`))));
    });
  });
  await afs.rename(tmp, out);
  return out;
}

// Read the first `max` non-empty lines of an index file. Used for the empty
// query (browse) case so we skip fzf entirely — fzf must read the whole index
// before emitting anything, which is the slow path we want to avoid.
export function readIndexHead(file: string, max: number): Promise<string[]> {
  return new Promise((resolve, reject) => {
    const results: string[] = [];
    const stream = fs.createReadStream(file);
    const rl = readline.createInterface({ input: stream });
    rl.on("line", (line) => {
      if (line.length === 0) return;
      results.push(line);
      if (results.length >= max) {
        rl.close();
        stream.destroy();
        resolve(results);
      }
    });
    rl.on("close", () => resolve(results));
    stream.on("error", reject);
  });
}

// Run `source` and return its lines directly (builtin-filter mode).
export async function runSourceLines(command: string, dropdownValue: string): Promise<string[]> {
  const { code, stdout, stderr } = await run(path.join(commandDir(command), "source"), [], {
    env: { PICKER_DROPDOWN: dropdownValue },
  });
  if (code !== 0) throw new Error(stderr.trim() || `source exited ${code}`);
  return stdout.split("\n").filter((l) => l.length > 0);
}

// Run `filter <query>` over a source file, streaming stdout line-by-line and
// killing the filter once MAX_RESULTS lines arrive. With an empty query fzf
// emits the entire index, so buffering it all (then slicing) was the source of
// the listing lag — an early kill keeps the first paint near-instant.
export function runFilter(command: string, query: string, sourceFile: string, signal: AbortSignal): Promise<string[]> {
  return new Promise((resolve, reject) => {
    const stdin = fs.openSync(sourceFile, "r");
    const child = spawn(path.join(commandDir(command), "filter"), [query], {
      stdio: [stdin, "pipe", "pipe"],
      env: spawnEnv(),
      signal,
    });
    const results: string[] = [];
    let stderr = "";
    let settled = false;
    const finish = (err?: Error) => {
      if (settled) return;
      settled = true;
      try {
        fs.closeSync(stdin);
      } catch {
        // already closed
      }
      if (err) reject(err);
      else resolve(results);
    };
    const rl = readline.createInterface({ input: child.stdout! });
    rl.on("line", (line) => {
      if (line.length === 0) return;
      results.push(line);
      if (results.length >= MAX_RESULTS) {
        rl.close();
        child.kill();
        finish();
      }
    });
    child.stderr?.on("data", (d) => (stderr += d.toString()));
    child.on("error", finish);
    child.on("close", (code) => {
      // A filter that finds nothing (e.g. fzf) exits non-zero with empty output.
      if (code !== 0 && results.length === 0 && stderr.trim().length > 0) {
        finish(new Error(stderr.trim()));
      } else {
        finish();
      }
    });
  });
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
