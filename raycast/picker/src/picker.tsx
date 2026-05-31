import {
  Action,
  ActionPanel,
  Clipboard,
  Icon,
  Keyboard,
  List,
  LocalStorage,
  Toast,
  closeMainWindow,
  showToast,
} from "@raycast/api";
import { useCachedState } from "@raycast/utils";
import afs from "fs/promises";
import path, { basename } from "path";
import { useEffect, useMemo, useRef, useState } from "react";
import {
  Config,
  Item,
  MAX_RESULTS,
  SinkMode,
  commandDir,
  loadConfig,
  parseItems,
  readIndexHead,
  runFilter,
  runSourceLines,
  runSourceToFile,
  runTargets,
} from "./lib/picker-core";

async function gatherContents(targets: string[]): Promise<string> {
  const parts = await Promise.all(
    targets.map(async (target) => {
      const stats = await afs.stat(target);
      const body = stats.isDirectory() ? (await afs.readdir(target)).join("\n") : await afs.readFile(target, "utf8");
      return targets.length > 1 ? `==> ${target} <==\n${body}` : body;
    }),
  );
  return parts.join("\n\n");
}

export function Picker({ command }: { command: string }) {
  const config = useMemo<Config>(() => loadConfig(command), [command]);
  const isFile = config.item_type === "file";
  const isStream = config.filter === "stream";

  const [dropdownValue, setDropdownValue] = useCachedState<string>(
    `dropdown-${command}`,
    config.dropdown?.items[0]?.value ?? "",
  );
  const [searchText, setSearchText] = useState("");
  const [items, setItems] = useState<Item[]>([]);
  const [loading, setLoading] = useState(true);
  const [sourceFile, setSourceFile] = useState<string | null>(null);
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [selectedItemId, setSelectedItemId] = useState<string | null>(null);

  // value -> last-used epoch ms, persisted per command. Used to float recently
  // acted-on items to the top of the browse list when config.recents is set.
  const [recents, setRecents] = useState<Record<string, number>>({});
  useEffect(() => {
    if (!config.recents) return;
    LocalStorage.getItem<string>(`recents-${command}`).then((raw) => {
      if (raw) setRecents(JSON.parse(raw) as Record<string, number>);
    });
  }, [command, config.recents]);

  function recordRecents(targets: string[]) {
    if (!config.recents) return;
    const now = Date.now();
    const next = { ...recents };
    for (const t of targets) next[t] = now;
    // Cap the store so it can't grow without bound.
    const trimmed = Object.fromEntries(
      Object.entries(next)
        .sort(([, a], [, b]) => b - a)
        .slice(0, 200),
    );
    setRecents(trimmed);
    LocalStorage.setItem(`recents-${command}`, JSON.stringify(trimmed));
  }

  // Keep the latest search text readable from the streaming source callback
  // without re-subscribing it on every keystroke.
  const searchTextRef = useRef("");
  useEffect(() => {
    searchTextRef.current = searchText;
  }, [searchText]);

  // Build the candidate list. Builtin mode loads everything and lets Raycast
  // filter. Stream mode writes source output to an index file, but paints rows
  // live as the source emits them so browsing feels instant on a cold index.
  useEffect(() => {
    let canceled = false;
    setLoading(true);
    setSourceFile(null);
    setItems([]);
    (async () => {
      try {
        if (isStream) {
          const file = await runSourceToFile(command, dropdownValue, (lines) => {
            // Only show the live browse stream while the query is empty;
            // a non-empty query will be served by the filter effect instead.
            if (canceled || searchTextRef.current.length > 0) return;
            setItems((prev) => {
              if (prev.length >= MAX_RESULTS) return prev;
              return [...prev, ...parseItems(lines, config.source_format, config.item_type)].slice(0, MAX_RESULTS);
            });
            setLoading(false);
          });
          if (!canceled) setSourceFile(file);
        } else {
          const lines = await runSourceLines(command, dropdownValue);
          if (!canceled) {
            setItems(parseItems(lines, config.source_format, config.item_type));
            setLoading(false);
          }
        }
      } catch (err) {
        if (!canceled) {
          setLoading(false);
          showToast({ style: Toast.Style.Failure, title: "source failed", message: (err as Error).message });
        }
      }
    })();
    return () => {
      canceled = true;
    };
  }, [command, dropdownValue, isStream, config.source_format, config.item_type]);

  // Stream mode: re-run the filter on every keystroke, ignoring stale results.
  const reqId = useRef(0);
  const abortRef = useRef<AbortController | null>(null);
  useEffect(() => {
    if (!isStream || !sourceFile) return;
    const id = ++reqId.current;
    abortRef.current?.abort();
    const controller = new AbortController();
    abortRef.current = controller;
    setLoading(true);
    (async () => {
      try {
        // Empty query: read the index head directly. fzf must consume the
        // whole index before emitting, so we only pay that cost when typing.
        const lines =
          searchText.length === 0
            ? await readIndexHead(sourceFile, MAX_RESULTS)
            : await runFilter(command, searchText, sourceFile, controller.signal);
        if (id === reqId.current) {
          setItems(parseItems(lines, config.source_format, config.item_type));
          setLoading(false);
        }
      } catch (err) {
        if (id === reqId.current && (err as Error).name !== "AbortError") {
          setLoading(false);
          showToast({ style: Toast.Style.Failure, title: "filter failed", message: (err as Error).message });
        }
      }
    })();
  }, [command, searchText, sourceFile, isStream, config.source_format, config.item_type]);

  function toggle(value: string) {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(value)) next.delete(value);
      else next.add(value);
      return next;
    });
    const idx = items.findIndex((it) => it.value === value);
    const nextItem = idx >= 0 ? items[idx + 1] : undefined;
    if (nextItem) setSelectedItemId(nextItem.value);
  }

  function targetsFor(hovered: string): string[] {
    return selected.size > 0 ? Array.from(new Set([...selected, hovered])) : [hovered];
  }

  // Stable sort floating recently-used items first. Only meaningful for the
  // empty-query browse view; Raycast re-ranks by match score once you type.
  const displayItems = useMemo(() => {
    if (!config.recents) return items;
    return [...items].sort((a, b) => (recents[b.value] ?? 0) - (recents[a.value] ?? 0));
  }, [items, recents, config.recents]);

  async function runExec(exe: string, targets: string[], mode: SinkMode, animatedTitle?: string) {
    let toast: Toast | undefined;
    if (animatedTitle) toast = await showToast({ style: Toast.Style.Animated, title: animatedTitle });
    try {
      await runTargets(exe, targets, mode);
      recordRecents(targets);
      await closeMainWindow();
    } catch (err) {
      if (toast) toast.hide();
      await showToast({ style: Toast.Style.Failure, title: "Action failed", message: (err as Error).message });
    }
  }

  function actionsFor(item: Item) {
    const targets = targetsFor(item.value);
    const count = targets.length;
    const suffix = count === 1 ? "" : ` (${count})`;
    const primaryBase = config.primary_title ?? (isFile ? "Open" : `Run on ${count} Item${count === 1 ? "" : "s"}`);
    const primaryTitle = config.primary_title || isFile ? `${primaryBase}${suffix}` : primaryBase;

    return (
      <ActionPanel>
        <ActionPanel.Section>
          <Action
            title={primaryTitle}
            icon={isFile ? Icon.Document : Icon.Play}
            onAction={() =>
              runExec(
                path.join(commandDir(command), "sink"),
                targets,
                config.sink_mode,
                isFile ? undefined : "Running…",
              )
            }
          />
          <Action
            title={selected.has(item.value) ? "Deselect" : "Select"}
            icon={selected.has(item.value) ? Icon.Circle : Icon.CheckCircle}
            shortcut={{ modifiers: ["cmd"], key: "return" }}
            onAction={() => toggle(item.value)}
          />
          {config.actions.map((a) => (
            <Action
              key={a.exec}
              title={`${a.title}${suffix}`}
              icon={Icon.Terminal}
              shortcut={a.shortcut as Keyboard.Shortcut | undefined}
              onAction={() => runExec(path.join(commandDir(command), a.exec), targets, a.sink_mode ?? config.sink_mode)}
            />
          ))}
          {isFile && (
            <>
              <Action.OpenWith path={item.value} shortcut={{ modifiers: ["cmd"], key: "o" }} />
              <Action.ShowInFinder path={item.value} />
              <Action.ToggleQuickLook shortcut={{ modifiers: ["cmd"], key: "y" }} />
            </>
          )}
        </ActionPanel.Section>
        {isFile ? (
          <ActionPanel.Section>
            <Action
              title={`Copy File${count === 1 ? "" : "s"}`}
              icon={Icon.CopyClipboard}
              shortcut={{ modifiers: ["cmd"], key: "c" }}
              onAction={async () => {
                try {
                  for (const t of targets) await Clipboard.copy({ file: t });
                  await showToast({ title: count === 1 ? "Copied file" : `Copied ${count} files` });
                } catch (err) {
                  await showToast({ style: Toast.Style.Failure, title: "Couldn't copy file", message: `${err}` });
                }
              }}
            />
            <Action
              title={`Paste File${count === 1 ? "" : "s"} to Current App`}
              icon={Icon.Clipboard}
              shortcut={{ modifiers: ["cmd"], key: "v" }}
              onAction={async () => {
                try {
                  for (const t of targets) await Clipboard.paste({ file: t });
                  await closeMainWindow();
                } catch (err) {
                  await showToast({ style: Toast.Style.Failure, title: "Couldn't paste file", message: `${err}` });
                }
              }}
            />
            <Action
              title={`Paste Path${count === 1 ? "" : "s"} to Current App`}
              icon={Icon.Clipboard}
              shortcut={{ modifiers: ["cmd", "ctrl"], key: "v" }}
              onAction={async () => {
                try {
                  await Clipboard.paste(targets.join("\n"));
                  await closeMainWindow();
                } catch (err) {
                  await showToast({ style: Toast.Style.Failure, title: "Couldn't paste path", message: `${err}` });
                }
              }}
            />
            <Action
              title={`Paste Contents to Current App${suffix}`}
              icon={Icon.Clipboard}
              shortcut={{ modifiers: ["cmd", "shift"], key: "v" }}
              onAction={async () => {
                try {
                  await Clipboard.paste(await gatherContents(targets));
                  await closeMainWindow();
                } catch (err) {
                  await showToast({ style: Toast.Style.Failure, title: "Couldn't paste contents", message: `${err}` });
                }
              }}
            />
            <Action
              title={`Copy Path${count === 1 ? "" : "s"} to Clipboard`}
              icon={Icon.CopyClipboard}
              shortcut={{ modifiers: ["cmd", "ctrl"], key: "c" }}
              onAction={async () => {
                await Clipboard.copy(targets.join("\n"));
                await showToast({ title: count === 1 ? "Copied path" : `Copied ${count} paths` });
              }}
            />
            <Action
              title={`Copy Contents to Clipboard${suffix}`}
              icon={Icon.Clipboard}
              shortcut={{ modifiers: ["cmd", "shift"], key: "c" }}
              onAction={async () => {
                try {
                  await Clipboard.copy(await gatherContents(targets));
                  await showToast({ title: count === 1 ? "Copied contents" : `Copied contents of ${count} items` });
                } catch (err) {
                  await showToast({ style: Toast.Style.Failure, title: "Couldn't copy contents", message: `${err}` });
                }
              }}
            />
          </ActionPanel.Section>
        ) : (
          <ActionPanel.Section>
            <Action
              title={`Copy${count === 1 ? "" : ` ${count}`} to Clipboard`}
              icon={Icon.CopyClipboard}
              shortcut={{ modifiers: ["cmd"], key: "c" }}
              onAction={async () => {
                await Clipboard.copy(targets.join("\n"));
                await showToast({ title: count === 1 ? "Copied to clipboard" : `Copied ${count} items` });
              }}
            />
          </ActionPanel.Section>
        )}
      </ActionPanel>
    );
  }

  return (
    <List
      isLoading={loading}
      searchBarPlaceholder={config.placeholder}
      filtering={isStream ? false : undefined}
      onSearchTextChange={isStream ? setSearchText : undefined}
      selectedItemId={selectedItemId ?? undefined}
      onSelectionChange={setSelectedItemId}
      searchBarAccessory={
        config.dropdown ? (
          <List.Dropdown
            tooltip={config.dropdown.tooltip ?? "Filter"}
            value={dropdownValue}
            onChange={setDropdownValue}
          >
            {config.dropdown.items.map((d) => (
              <List.Dropdown.Item key={d.value} title={d.title} value={d.value} />
            ))}
          </List.Dropdown>
        ) : undefined
      }
    >
      {displayItems.map((item) => (
        <List.Item
          key={item.value}
          id={item.value}
          title={item.title}
          subtitle={item.subtitle}
          icon={selected.has(item.value) ? Icon.CheckCircle : Icon.Circle}
          accessories={selected.size > 0 ? [{ text: `${selected.size} selected` }] : undefined}
          quickLook={isFile ? { path: item.value, name: basename(item.value) } : undefined}
          actions={actionsFor(item)}
        />
      ))}
    </List>
  );
}
