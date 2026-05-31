#!/usr/bin/env node
// Fails the build if any command script under assets/commands/<cmd>/ is not
// executable. Raycast deploys these with their source mode, and Node spawns
// them directly, so a non-executable script => EACCES => "action failed" toast
// at runtime. Catch it here instead.
import { readdirSync, statSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const commandsDir = join(root, "assets", "commands");

// Files in a command dir that are data, not executables.
const NON_SCRIPTS = new Set(["config.json"]);

const offenders = [];
let commandDirs;
try {
  commandDirs = readdirSync(commandsDir, { withFileTypes: true });
} catch {
  process.exit(0); // no commands dir; nothing to check
}

for (const cmd of commandDirs) {
  if (!cmd.isDirectory()) continue;
  const dir = join(commandsDir, cmd.name);
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (!entry.isFile()) continue;
    if (NON_SCRIPTS.has(entry.name)) continue;
    const full = join(dir, entry.name);
    // executable by owner?
    if ((statSync(full).mode & 0o100) === 0) {
      offenders.push(`assets/commands/${cmd.name}/${entry.name}`);
    }
  }
}

if (offenders.length > 0) {
  console.error("Non-executable command script(s) found:");
  for (const o of offenders) console.error(`  ${o}`);
  console.error("\nFix with:");
  console.error(`  chmod +x ${offenders.join(" ")}`);
  process.exit(1);
}
