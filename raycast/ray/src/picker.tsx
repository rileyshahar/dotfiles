import { Action, ActionPanel, Icon, List, Toast, closeMainWindow, environment, showToast } from "@raycast/api";
import { spawn } from "child_process";
import { readFileSync } from "fs";
import { join } from "path";
import { useEffect, useMemo, useState } from "react";

type SinkMode = "all" | "each";
type Config = { sink_mode: SinkMode; placeholder?: string };

const commandDir = (command: string) => join(environment.assetsPath, "commands", command);

function loadConfig(command: string): Config {
  const raw = readFileSync(join(commandDir(command), "config.json"), "utf8");
  const parsed = JSON.parse(raw) as Config;
  return { sink_mode: parsed.sink_mode, placeholder: parsed.placeholder ?? "Filter…" };
}

function runCommand(
  cmd: string,
  args: string[],
  input?: string,
): Promise<{ code: number; stdout: string; stderr: string }> {
  return new Promise((resolve, reject) => {
    const child = spawn(cmd, args, { stdio: [input === undefined ? "ignore" : "pipe", "pipe", "pipe"] });
    let stdout = "";
    let stderr = "";
    child.stdout.on("data", (d) => (stdout += d.toString()));
    child.stderr.on("data", (d) => (stderr += d.toString()));
    child.on("error", reject);
    child.on("close", (code) => resolve({ code: code ?? 0, stdout, stderr }));
    if (input !== undefined) child.stdin.end(input);
  });
}

export function Picker({ command }: { command: string }) {
  const config = useMemo(() => loadConfig(command), [command]);
  const [items, setItems] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [selectedItemId, setSelectedItemId] = useState<string | null>(null);

  useEffect(() => {
    const child = spawn(join(commandDir(command), "source"), [], { stdio: ["ignore", "pipe", "pipe"] });
    let stdout = "";
    let stderr = "";
    child.stdout.on("data", (d) => (stdout += d.toString()));
    child.stderr.on("data", (d) => (stderr += d.toString()));
    child.on("close", (code) => {
      setLoading(false);
      if (code !== 0) {
        showToast({ style: Toast.Style.Failure, title: "source failed", message: stderr.trim() || `exit ${code}` });
        return;
      }
      setItems(stdout.split("\n").filter((l) => l.length > 0));
    });
    child.on("error", (err) => {
      setLoading(false);
      showToast({ style: Toast.Style.Failure, title: "source failed to start", message: err.message });
    });
  }, [command]);

  function toggle(line: string) {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(line)) next.delete(line);
      else next.add(line);
      return next;
    });
    // Advance the hover to the next item so repeated toggles select a run.
    const idx = items.indexOf(line);
    const nextItem = idx >= 0 ? items[idx + 1] : undefined;
    if (nextItem) setSelectedItemId(nextItem);
  }

  async function run(hovered: string) {
    const lines = selected.size > 0 ? Array.from(new Set([...selected, hovered])) : [hovered];
    const sink = join(commandDir(command), "sink");
    await showToast({
      style: Toast.Style.Animated,
      title: `Running on ${lines.length} item${lines.length === 1 ? "" : "s"}…`,
    });
    try {
      if (config.sink_mode === "each") {
        const results = await Promise.all(lines.map((l) => runCommand(sink, [l])));
        const failures = results.filter((r) => r.code !== 0);
        if (failures.length > 0) {
          showToast({
            style: Toast.Style.Failure,
            title: `sink failed for ${failures.length}/${lines.length}`,
            message: failures[0].stderr.trim(),
          });
          return;
        }
      } else {
        const { code, stderr } = await runCommand(sink, [], lines.join("\n") + "\n");
        if (code !== 0) {
          showToast({ style: Toast.Style.Failure, title: "sink failed", message: stderr.trim() || `exit ${code}` });
          return;
        }
      }
      showToast({ style: Toast.Style.Success, title: `Done (${lines.length})` });
      await closeMainWindow();
    } catch (err) {
      showToast({ style: Toast.Style.Failure, title: "sink failed to start", message: (err as Error).message });
    }
  }

  const runCount = (hovered: string) => (selected.size > 0 ? new Set([...selected, hovered]).size : 1);

  return (
    <List
      isLoading={loading}
      searchBarPlaceholder={config.placeholder}
      selectedItemId={selectedItemId ?? undefined}
      onSelectionChange={setSelectedItemId}
    >
      {items.map((line) => (
        <List.Item
          key={line}
          id={line}
          title={line}
          icon={selected.has(line) ? Icon.CheckCircle : Icon.Circle}
          accessories={selected.size > 0 ? [{ text: `${selected.size} selected` }] : undefined}
          actions={
            <ActionPanel>
              <Action
                title={`Run on ${runCount(line)} Item${runCount(line) === 1 ? "" : "s"}`}
                icon={Icon.Play}
                onAction={() => run(line)}
              />
              <Action
                title="Toggle Selection"
                icon={Icon.CheckCircle}
                shortcut={{ modifiers: ["shift"], key: "return" }}
                onAction={() => toggle(line)}
              />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
