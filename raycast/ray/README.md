# Source | fzf | Sink

A Raycast extension that hosts a stable of pickers, where each picker is just a
pair of executables. Pick lines, hit enter, the lines pipe into the sink.

## Setup

```sh
npm install
npm run dev
```

Open Raycast and search for "Open File" — that's the bundled example.

## The one-line story

Each command is two executables:

- `assets/commands/<name>/source` produces newline-separated lines on stdout.
- `assets/commands/<name>/sink` consumes the selected lines on stdin.

That's it. The TypeScript wrapper (`src/<name>.tsx`) is two lines and
auto-generated.

## Adding a command

```sh
./scripts/add-command my-command
```

This scaffolds `assets/commands/my-command/{source,sink,config.json}`, writes a
`src/my-command.tsx` wrapper, and appends an entry to `package.json`. Edit the
two scripts and Raycast hot-reloads.

## `source` contract

- Must be executable.
- Writes newline-separated lines to stdout.
- Exits 0 on success. Nonzero shows an error toast with stderr.
- Any language is fine — bash, Python, a compiled binary, whatever.

## `sink` contract

- Must be executable.
- Under `sink_mode: "all"` it's called once with all selected lines joined by
  newlines on stdin (trailing newline included).
- Under `sink_mode: "each"` it's called once per selected line, in parallel,
  with the selected line passed as argv `$1`.
- Any language is fine.

## `config.json`

```json
{
  "sink_mode": "all",
  "placeholder": "Filter files…"
}
```

- `sink_mode`: `"all"` or `"each"`.
- `placeholder`: optional, defaults to `"Filter…"`.

## Selection UX

- Enter runs the sink. If nothing is selected, runs on the hovered line. If
  things are selected, runs on the union of the selection and the hovered line.
- Shift+Enter toggles the hovered line in the selection set.

## Removing a command

Three file ops:

```sh
rm -r assets/commands/<name>
rm src/<name>.tsx
# then remove the entry from package.json `commands[]`
```

## Notes

- This template doesn't commit `package-lock.json`. In your own fork, do.
- Node 20+ required.
