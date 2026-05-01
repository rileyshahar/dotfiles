// f15 -- homerow
// f16 -- raycast
// f17 -- raycast kagi
// f18 -- leaderkey

import {
  FromKeyParam,
  FromModifierParam,
  ifApp,
  ifVar,
  map,
  Modifier,
  rule,
  to$,
  ToEvent,
  ToKeyCode,
  writeToGlobal,
  writeToProfile,
} from "karabiner.ts";

/** -----------------------------
 *  Constants / Vars / Modes
 *  ----------------------------- */

const FN = {
  KANDO: "f13",
  RAYCAST_SEARCH_MENU_ITEMS: "f14",
  HOME_ROW: "f15",
  RAYCAST: "f16",
  RAYCAST_GOOGLE: "f17",
  LEADER: "f18",
  RAYCAST_WIKI: "f19",
} as const;

const VAR = {
  MODE: "mode",
  // Reserved for future use (kept for compatibility with existing Hammerspoon setup)
  TEXT_INPUT: "in_text_input",

  // vim-mode-plus-like prefixes/operators (normal mode)
  VIM_OP: "vim_op",
  VIM_G_PREFIX: "vim_g_prefix",
} as const;

const MODE = {
  app: 0,
  ins: 1,
  nrm: 2,
  vis: 3,
  ign: 4,
} as const;

type Mode = keyof typeof MODE;

const BYPASS_APPS = ["com.neovide.neovide", "org.mozilla.firefox"] as const;

/** -----------------------------
 *  Hammerspoon integration
 *  ----------------------------- */

const HS_BIN = "/opt/homebrew/bin/hs";

// Use JSON.stringify to safely quote/escape the lua string in shell
const hs = (lua: string) => `${HS_BIN} -c ${JSON.stringify(lua)}`;

// Delegates to Hammerspoon `setMode(..)`
const setMode = (m: Mode) => to$(hs(`setMode('${m}')`));

/** -----------------------------
 *  Conditions (vim enable + mode)
 *  ----------------------------- */

const modeIs = (m: Mode) => ifVar(VAR.MODE, MODE[m]);

const vimOff = modeIs("ign");
const vimOn = vimOff.unless();

const vimActive = [
  vimOn,
  ...BYPASS_APPS.map((bundleId) => ifApp(bundleId).unless()),
];

const vimMode = (m: Mode) => [...vimActive, modeIs(m)];

/** -----------------------------
 *  Small building blocks
 *  ----------------------------- */

// Adds halt:true to avoid double-firing alongside to_delayed_action.
const haltKey = (key_code: ToKeyCode, modifiers?: Modifier[]) =>
  ({ key_code, modifiers, halt: true }) as const;

const mapFrom = (
  from: FromKeyParam,
  mods: FromModifierParam | "" | undefined,
) => {
  if (mods === undefined) return map(from, "optionalAny");
  if (mods === "") return map(from);
  return map(from, mods);
};

// Karabiner set_variable event
const setVar = (name: string, value: number) =>
  ({ set_variable: { name, value } }) as const;

const clearVimPlus = () => [setVar(VAR.VIM_OP, 0), setVar(VAR.VIM_G_PREFIX, 0)];

// Transition helper (also clears any pending vim-mode-plus prefix/operator state)
const modeTransition = (
  key: FromKeyParam,
  from: Mode | readonly Mode[],
  to: Mode,
) =>
  (Array.isArray(from) ? from : [from]).map((m) =>
    map(key)
      .condition(...vimMode(m))
      .to(clearVimPlus()[0])
      .to(clearVimPlus()[1])
      .to(setMode(to)),
  );

type DualRoleOpts = {
  fromMods?: FromModifierParam | "";
  immediateTo?: ToEvent;
  alone: { key_code: ToKeyCode; mods?: Modifier[] };
  heldDown: ToEvent;
};

const dualRole = (fromKey: FromKeyParam, opts: DualRoleOpts) => {
  const alone = haltKey(opts.alone.key_code, opts.alone.mods);

  let m = mapFrom(fromKey, opts.fromMods);
  if (opts.immediateTo) m = m.to(opts.immediateTo);

  return m
    .toIfAlone(alone)
    .toIfHeldDown(opts.heldDown)
    .toDelayedAction([], [alone]);
};

type KeySpec = {
  from: FromKeyParam;
  fromMods?: FromModifierParam | "";
  to: ToEvent;
};

const appConfig = (name: string, bundleId: string, keys: readonly KeySpec[]) =>
  rule(`[vim] ${name} (app only)`).manipulators(
    keys.map(({ from, fromMods, to }) =>
      mapFrom(from, fromMods)
        .condition(ifApp(bundleId), ...vimMode("app"))
        .to(to),
    ),
  );

/** -----------------------------
 *  Navigation mappings
 *  ----------------------------- */

const ARROW_OF = {
  h: "left_arrow",
  j: "down_arrow",
  k: "up_arrow",
  l: "right_arrow",
} as const;

type ArrowKey = keyof typeof ARROW_OF;

// vim-mode-plus note: hjkl should work with shift/control/option/command held.
// We generate all combinations (16) for NORMAL mode only.
const PASS_MODS = [
  { sym: "⌘", to: "left_command" as const },
  { sym: "⌥", to: "left_option" as const },
  { sym: "⌃", to: "left_control" as const },
  { sym: "⇧", to: "left_shift" as const },
] as const;

const modifierCombos = (): Array<{
  fromMods: FromModifierParam | "";
  toMods?: Modifier[];
}> => {
  const combos: Array<{
    fromMods: FromModifierParam | "";
    toMods?: Modifier[];
  }> = [];
  for (let mask = 0; mask < 1 << PASS_MODS.length; mask++) {
    const syms: string[] = [];
    const mods: Modifier[] = [];
    for (let i = 0; i < PASS_MODS.length; i++) {
      if (mask & (1 << i)) {
        syms.push(PASS_MODS[i].sym);
        mods.push(PASS_MODS[i].to);
      }
    }
    combos.push({
      fromMods: (syms.join("") as unknown as FromModifierParam) || "",
      toMods: mods.length ? mods : undefined,
    });
  }
  return combos;
};

const hjklNormalWithModifiers = () =>
  modifierCombos().flatMap(({ fromMods, toMods }) =>
    (Object.keys(ARROW_OF) as ArrowKey[]).map((k) =>
      mapFrom(k, fromMods)
        .condition(...vimMode("nrm"), ifVar(VAR.VIM_OP, 0))
        .to({ key_code: ARROW_OF[k], modifiers: toMods }),
    ),
  );

// Existing simple hjkl for app/vis
const hjkl = (mode: Mode, mods?: Modifier[]) =>
  (Object.keys(ARROW_OF) as ArrowKey[]).map((k) =>
    map(k)
      .condition(...vimMode(mode))
      .to({ key_code: ARROW_OF[k], modifiers: mods }),
  );

/** -----------------------------
 *  vim-mode-plus NORMAL mode commands
 *  ----------------------------- */

const OP = {
  none: 0,
  d: 1,
  y: 2,
  c: 3,
} as const;
type Op = keyof typeof OP;

const opIs = (op: Op) => ifVar(VAR.VIM_OP, OP[op]);
const gPrefixIs = (v: 0 | 1) => ifVar(VAR.VIM_G_PREFIX, v);

const CMD_X: ToEvent = { key_code: "x", modifiers: ["left_command"] };
const CMD_C: ToEvent = { key_code: "c", modifiers: ["left_command"] };
const CMD_V: ToEvent = { key_code: "v", modifiers: ["left_command"] };
const CMD_Z: ToEvent = { key_code: "z", modifiers: ["left_command"] };
const CMD_SHIFT_Z: ToEvent = {
  key_code: "z",
  modifiers: ["left_command", "left_shift"],
};

type MotionSpec = {
  from: FromKeyParam;
  fromMods?: FromModifierParam | "";
  move: ToEvent;
  select: ToEvent; // same movement but with shift added
};

// “navigation keys mentioned above” from vim-mode-plus NORMAL mode :contentReference[oaicite:1]{index=1}
const MOTIONS: readonly MotionSpec[] = [
  // hjkl
  {
    from: "h",
    move: { key_code: "left_arrow" },
    select: { key_code: "left_arrow", modifiers: ["left_shift"] },
  },
  {
    from: "j",
    move: { key_code: "down_arrow" },
    select: { key_code: "down_arrow", modifiers: ["left_shift"] },
  },
  {
    from: "k",
    move: { key_code: "up_arrow" },
    select: { key_code: "up_arrow", modifiers: ["left_shift"] },
  },
  {
    from: "l",
    move: { key_code: "right_arrow" },
    select: { key_code: "right_arrow", modifiers: ["left_shift"] },
  },

  // e / b (word)
  {
    from: "e",
    move: { key_code: "right_arrow", modifiers: ["left_option"] },
    select: {
      key_code: "right_arrow",
      modifiers: ["left_shift", "left_option"],
    },
  },
  {
    from: "b",
    move: { key_code: "left_arrow", modifiers: ["left_option"] },
    select: {
      key_code: "left_arrow",
      modifiers: ["left_shift", "left_option"],
    },
  },

  // 0 / ^ / $
  {
    from: "0",
    move: { key_code: "home" },
    select: { key_code: "home", modifiers: ["left_shift"] },
  },
  {
    // ^ is shift+6 on US layout
    from: "6",
    fromMods: "shift",
    move: { key_code: "left_arrow", modifiers: ["left_command"] },
    select: {
      key_code: "left_arrow",
      modifiers: ["left_shift", "left_command"],
    },
  },
  {
    // $ is shift+4 on US layout
    from: "4",
    fromMods: "shift",
    move: { key_code: "end" },
    select: { key_code: "end", modifiers: ["left_shift"] },
  },

  // { / }
  {
    // { is shift+[
    from: "open_bracket",
    fromMods: "shift",
    move: { key_code: "up_arrow", modifiers: ["left_option"] },
    select: {
      key_code: "up_arrow",
      modifiers: ["left_shift", "left_option"],
    },
  },
  {
    // } is shift+]
    from: "close_bracket",
    fromMods: "shift",
    move: { key_code: "down_arrow", modifiers: ["left_option"] },
    select: {
      key_code: "down_arrow",
      modifiers: ["left_shift", "left_option"],
    },
  },

  // G (end of doc)
  {
    from: "g",
    fromMods: "shift",
    move: { key_code: "down_arrow", modifiers: ["left_command"] },
    select: {
      key_code: "down_arrow",
      modifiers: ["left_shift", "left_command"],
    },
  },
] as const;

const normalMove = MOTIONS.filter(
  (m) => m.from !== "h" && m.from !== "j" && m.from !== "k" && m.from !== "l",
).map(({ from, fromMods, move }) =>
  mapFrom(from, fromMods)
    .condition(...vimMode("nrm"), opIs("none"), gPrefixIs(0))
    .to(move),
);

// gg (start of doc) is special (two-key sequence)
const normalGg = [
  // first g (no operator)
  map("g")
    .condition(...vimMode("nrm"), opIs("none"), gPrefixIs(0))
    .to(setVar(VAR.VIM_G_PREFIX, 1))
    .toDelayedAction([setVar(VAR.VIM_G_PREFIX, 0)], []),

  // second g (no operator): move to start of doc
  map("g")
    .condition(...vimMode("nrm"), opIs("none"), gPrefixIs(1))
    .to(setVar(VAR.VIM_G_PREFIX, 0))
    .to({ key_code: "up_arrow", modifiers: ["left_command"] }),
];

// Operators (d/y/c) + motion, including gg
const opPrefix = (op: Exclude<Op, "none">, key: FromKeyParam) =>
  map(key)
    .condition(...vimMode("nrm"), opIs("none"))
    .to(setVar(VAR.VIM_OP, OP[op]))
    .toDelayedAction([setVar(VAR.VIM_OP, 0)], []);

const opWithMotion = (op: Exclude<Op, "none">, motion: MotionSpec) => {
  const base = mapFrom(motion.from, motion.fromMods).condition(
    ...vimMode("nrm"),
    opIs(op),
  );

  if (op === "d") {
    return base
      .to(motion.select)
      .to(CMD_X)
      .to(setVar(VAR.VIM_OP, 0))
      .to(setVar(VAR.VIM_G_PREFIX, 0));
  }

  if (op === "y") {
    return base
      .to(motion.select)
      .to(CMD_C)
      .to({ key_code: "left_arrow" }) // collapse selection (approx)
      .to(setVar(VAR.VIM_OP, 0))
      .to(setVar(VAR.VIM_G_PREFIX, 0));
  }

  // found op === "c"
  return base
    .to(motion.select)
    .to(CMD_X)
    .to(setVar(VAR.VIM_OP, 0))
    .to(setVar(VAR.VIM_G_PREFIX, 0))
    .to(setMode("ins"));
};

// dd/yy/cc (entire line)
const opLine = (op: Exclude<Op, "none">, key: FromKeyParam) => {
  const base = map(key).condition(...vimMode("nrm"), opIs(op));
  const selectLine = [
    { key_code: "home" } as const,
    { key_code: "end", modifiers: ["left_shift"] as Modifier[] } as const,
  ];

  if (op === "d") {
    return base
      .to(selectLine[0])
      .to(selectLine[1])
      .to(CMD_X)
      .to(setVar(VAR.VIM_OP, 0))
      .to(setVar(VAR.VIM_G_PREFIX, 0));
  }
  if (op === "y") {
    return base
      .to(selectLine[0])
      .to(selectLine[1])
      .to(CMD_C)
      .to({ key_code: "left_arrow" })
      .to(setVar(VAR.VIM_OP, 0))
      .to(setVar(VAR.VIM_G_PREFIX, 0));
  }
  // c
  return base
    .to(selectLine[0])
    .to(selectLine[1])
    .to(CMD_X)
    .to(setVar(VAR.VIM_OP, 0))
    .to(setVar(VAR.VIM_G_PREFIX, 0))
    .to(setMode("ins"));
};

// g prefix while operator pending (for dgg/ygg/cgg)
const opGPrefix = (op: Exclude<Op, "none">) =>
  map("g")
    .condition(...vimMode("nrm"), opIs(op), gPrefixIs(0))
    .to(setVar(VAR.VIM_G_PREFIX, 1))
    .toDelayedAction([setVar(VAR.VIM_G_PREFIX, 0)], []);

const opGgSecond = (op: Exclude<Op, "none">) => {
  const base = map("g").condition(...vimMode("nrm"), opIs(op), gPrefixIs(1));

  if (op === "d") {
    return base
      .to(setVar(VAR.VIM_G_PREFIX, 0))
      .to({ key_code: "up_arrow", modifiers: ["left_shift", "left_command"] })
      .to(CMD_X)
      .to(setVar(VAR.VIM_OP, 0));
  }
  if (op === "y") {
    return base
      .to(setVar(VAR.VIM_G_PREFIX, 0))
      .to({ key_code: "up_arrow", modifiers: ["left_shift", "left_command"] })
      .to(CMD_C)
      .to({ key_code: "left_arrow" })
      .to(setVar(VAR.VIM_OP, 0));
  }
  // c
  return base
    .to(setVar(VAR.VIM_G_PREFIX, 0))
    .to({ key_code: "up_arrow", modifiers: ["left_shift", "left_command"] })
    .to(CMD_X)
    .to(setVar(VAR.VIM_OP, 0))
    .to(setMode("ins"));
};

/** -----------------------------
 *  Global / Profile
 *  ----------------------------- */

writeToGlobal({
  show_in_menu_bar: false,
  show_profile_name_in_menu_bar: true,
});

const BASIC_DELAYS = {
  "basic.to_delayed_action_delay_milliseconds": 150,
  "basic.to_if_alone_timeout_milliseconds": 150,
  "basic.to_if_held_down_threshold_milliseconds": 150,
} as const;

/** -----------------------------
 *  Declarative mapping tables
 *  ----------------------------- */

const APP_MAIL_KEYS: readonly KeySpec[] = [
  // archive
  {
    from: "a",
    to: { key_code: "a", modifiers: ["left_command", "left_control"] },
  },
  // forward
  {
    from: "f",
    to: { key_code: "f", modifiers: ["left_command", "left_shift"] },
  },
  // reply all
  {
    from: "r",
    fromMods: "",
    to: { key_code: "r", modifiers: ["left_command", "left_shift"] },
  },
  // reply
  {
    from: "r",
    fromMods: "shift",
    to: { key_code: "r", modifiers: ["left_command"] },
  },
  // toggle read
  {
    from: "t",
    to: { key_code: "u", modifiers: ["left_command", "left_shift"] },
  },
] as const;

const TAPPED_MODIFIERS: Array<{
  from: FromKeyParam;
  opts: DualRoleOpts;
}> = [
  {
    from: "left_command",
    opts: {
      alone: { key_code: FN.LEADER },
      heldDown: { key_code: "left_command" },
    },
  },
  {
    from: "right_command",
    opts: {
      alone: { key_code: FN.RAYCAST },
      heldDown: { key_code: "right_command" },
    },
  },
  {
    from: "right_option",
    opts: {
      alone: { key_code: FN.RAYCAST_GOOGLE },
      heldDown: { key_code: "right_option" },
    },
  },
  {
    from: "left_option",
    opts: {
      alone: { key_code: FN.RAYCAST_SEARCH_MENU_ITEMS },
      heldDown: { key_code: "left_option" },
    },
  },
  {
    from: "left_shift",
    opts: {
      alone: { key_code: FN.KANDO },
      heldDown: { key_code: "left_shift" },
    },
  },
] as const;

const APP_SAFARI_KEYS: readonly KeySpec[] = [
  // history back/forward (Mail-style single-key app bindings)
  {
    from: "h",
    fromMods: "control",
    to: { key_code: "open_bracket", modifiers: ["left_command"] },
  },
  {
    from: "l",
    fromMods: "control",
    to: { key_code: "close_bracket", modifiers: ["left_command"] },
  },

  // tab switching (previous / next tab)
  {
    from: "h",
    fromMods: "shift",
    to: { key_code: "tab", modifiers: ["left_control", "left_shift"] },
  },
  {
    from: "l",
    fromMods: "shift",
    to: { key_code: "tab", modifiers: ["left_control"] },
  },

  // basics
  {
    from: "o",
    fromMods: "",
    to: { key_code: "l", modifiers: ["left_command"] }, // focus address bar
  },
  {
    from: "t",
    fromMods: "",
    to: { key_code: "t", modifiers: ["left_command"] }, // new tab
  },
  {
    from: "w",
    fromMods: "",
    to: { key_code: "w", modifiers: ["left_command"] }, // close tab
  },
  {
    from: "u",
    fromMods: "",
    to: { key_code: "t", modifiers: ["left_command", "left_shift"] }, // reopen closed tab
  },
  {
    from: "p",
    fromMods: "",
    to: { key_code: "n", modifiers: ["left_command", "left_shift"] }, // new private window
  },

  // page actions
  {
    from: "r",
    fromMods: "",
    to: { key_code: "r", modifiers: ["left_command"] }, // reload
  },
  {
    from: "r",
    fromMods: "shift",
    to: { key_code: "r", modifiers: ["left_command", "left_option"] }, // hard reload (reload from origin)
  },
  {
    from: "slash",
    fromMods: "",
    to: { key_code: "f", modifiers: ["left_command"] }, // find in page
  },
  {
    from: "n",
    fromMods: "",
    to: { key_code: "g", modifiers: ["left_command"] }, // find next
  },
  {
    from: "n",
    fromMods: "shift",
    to: { key_code: "g", modifiers: ["left_command", "left_shift"] }, // find previous
  },

  // views / lists
  {
    from: "y",
    fromMods: "",
    to: { key_code: "y", modifiers: ["left_command"] }, // history
  },
  {
    from: "d",
    fromMods: "",
    to: { key_code: "l", modifiers: ["left_command", "left_option"] }, // downloads
  },
  {
    from: "s",
    fromMods: "",
    to: { key_code: "l", modifiers: ["left_command", "left_shift"] }, // toggle sidebar
  },
  {
    from: "b",
    fromMods: "",
    to: { key_code: "1", modifiers: ["left_command", "left_control"] }, // bookmarks sidebar
  },
  {
    from: "q",
    fromMods: "",
    to: { key_code: "2", modifiers: ["left_command", "left_control"] }, // reading list sidebar
  },
  {
    from: "b",
    fromMods: "shift",
    to: { key_code: "b", modifiers: ["left_command", "left_shift"] }, // toggle favorites bar
  },
  {
    from: "e",
    fromMods: "",
    to: { key_code: "backslash", modifiers: ["left_command", "left_shift"] }, // tab overview
  },
  {
    from: "v",
    fromMods: "",
    to: { key_code: "r", modifiers: ["left_command", "left_shift"] }, // reader mode
  },
  {
    from: "a",
    fromMods: "",
    to: { key_code: "d", modifiers: ["left_command", "left_shift"] }, // add to reading list
  },

  // dev tools
  {
    from: "i",
    fromMods: "",
    to: { key_code: "i", modifiers: ["left_command", "left_option"] }, // Web Inspector
  },
] as const;

const APP_SKIM_KEYS: readonly KeySpec[] = [
  // search
  {
    from: "slash",
    fromMods: "",
    to: { key_code: "f", modifiers: ["left_command"] },
  },
  {
    from: "n",
    fromMods: "",
    to: { key_code: "g", modifiers: ["left_command"] }, // find next
  },
  {
    from: "n",
    fromMods: "shift",
    to: { key_code: "g", modifiers: ["left_command", "left_shift"] }, // find previous
  },

  // page navigation
  {
    from: "j",
    fromMods: "shift",
    to: { key_code: "page_down" }, // next page
  },
  {
    from: "k",
    fromMods: "shift",
    to: { key_code: "page_up" }, // previous page
  },

  // zoom
  {
    from: "equal_sign",
    fromMods: "shift", // +
    to: { key_code: "equal_sign", modifiers: ["left_command"] }, // zoom in
  },
  {
    from: "hyphen",
    fromMods: "",
    to: { key_code: "hyphen", modifiers: ["left_command"] }, // zoom out
  },
  {
    from: "0",
    fromMods: "",
    to: { key_code: "0", modifiers: ["left_command"] }, // actual size
  },

  // views
  {
    from: "s",
    fromMods: "",
    to: { key_code: "t", modifiers: ["left_command", "left_shift"] }, // toggle sidebar
  },
  {
    from: "f",
    fromMods: "",
    to: { key_code: "f", modifiers: ["left_command", "left_control"] }, // full screen
  },
  {
    from: "p",
    fromMods: "",
    to: { key_code: "p", modifiers: ["left_command", "left_shift"] }, // presentation mode
  },

  // page display
  {
    from: "1",
    fromMods: "",
    to: { key_code: "1", modifiers: ["left_command"] }, // single page
  },
  {
    from: "2",
    fromMods: "",
    to: { key_code: "2", modifiers: ["left_command"] }, // two pages
  },
] as const;

const HOME_ROW_HELD_MODS: Array<{
  from: FromKeyParam;
  immediateTo?: ToEvent;
  alone: ToKeyCode;
  held: ToKeyCode;
}> = [
  // tab: immediate cmd when held, tab when alone
  {
    from: "tab",
    immediateTo: { key_code: "left_command" },
    alone: "tab",
    held: "left_command",
  },

  // caps_lock: immediate ctrl when held, esc when alone
  {
    from: "caps_lock",
    immediateTo: { key_code: "left_control" },
    alone: "escape",
    held: "left_control",
  },

  // home row mods (held-only)
  { from: "a", alone: "a", held: "left_shift" },
  { from: "s", alone: "s", held: "left_control" },
  { from: "d", alone: "d", held: "left_option" },
  { from: "f", alone: "f", held: "left_command" },
] as const;

/** -----------------------------
 *  Rules
 *  ----------------------------- */

const rules = [
  rule("[vim] toggle modes").manipulators([
    // F3 toggles vim
    map("f3").condition(vimOff).to(setMode("ins")),
    map("f3").condition(vimOn).to(setMode("ign")),

    // ESC / C-[ -> Normal from ins/vis/app
    ...modeTransition("escape", ["ins", "vis", "app"], "nrm"),

    // i/v from Normal
    ...modeTransition("i", "nrm", "ins"),
    ...modeTransition("v", "nrm", "vis"),

    // NOTE: app mode entry moved from "a" -> "spacebar" (because a/A are vim-mode-plus exit keys)
    ...modeTransition("spacebar", "nrm", "app"),
  ]),

  appConfig("apple mail", "com.apple.mail", APP_MAIL_KEYS),
  appConfig("apple mail", "com.apple.Safari", APP_SAFARI_KEYS),
  appConfig("skim", "net.sourceforge.skim-app.skim", APP_SKIM_KEYS),

  rule("[vim] movement").manipulators([
    // NORMAL: hjkl (with modifier pass-through)
    ...hjklNormalWithModifiers(),

    // APP: keep simple hjkl (no modifier pass-through)
    ...hjkl("app"),

    // VIS: selection with hjkl
    ...hjkl("vis", ["left_shift"]),
  ]),

  rule("[vim] normal-mode-plus (vim-mode-plus normal commands)").manipulators([
    // Plain movement keys (non-hjkl)
    ...normalMove,
    ...normalGg,

    // Operators: d/y/c prefix
    opPrefix("d", "d"),
    opPrefix("y", "y"),
    opPrefix("c", "c"),

    // dd/yy/cc
    opLine("d", "d"),
    opLine("y", "y"),
    opLine("c", "c"),

    // d/y/c + motions (includes hjkl, e/b, 0/^/$, { }, G)
    ...MOTIONS.flatMap((m) => [
      opWithMotion("d", m),
      opWithMotion("y", m),
      opWithMotion("c", m),
    ]),

    // dgg / ygg / cgg
    opGPrefix("d"),
    opGPrefix("y"),
    opGPrefix("c"),
    opGgSecond("d"),
    opGgSecond("y"),
    opGgSecond("c"),

    // Also: x/X, p/P, u, C-r :contentReference[oaicite:2]{index=2}
    map("x")
      .condition(...vimMode("nrm"), opIs("none"))
      .to({ key_code: "delete_forward" }),
    mapFrom("x", "shift")
      .condition(...vimMode("nrm"), opIs("none"))
      .to({ key_code: "delete_or_backspace" }),

    map("p")
      .condition(...vimMode("nrm"), opIs("none"))
      .to(CMD_V),
    mapFrom("p", "shift")
      .condition(...vimMode("nrm"), opIs("none"))
      .to(CMD_V),

    map("u")
      .condition(...vimMode("nrm"), opIs("none"))
      .to(CMD_Z),
    mapFrom("r", "control")
      .condition(...vimMode("nrm"), opIs("none"))
      .to(CMD_SHIFT_Z),

    // Exit NORMAL mode at specific locations: i/I/a/A/o/O :contentReference[oaicite:3]{index=3}
    // i handled by modeTransition above

    // I: start of line then insert
    mapFrom("i", "shift")
      .condition(...vimMode("nrm"), opIs("none"))
      .to({ key_code: "home" })
      .to(clearVimPlus()[0])
      .to(clearVimPlus()[1])
      .to(setMode("ins")),

    // a: after cursor then insert
    map("a")
      .condition(...vimMode("nrm"), opIs("none"))
      .to({ key_code: "right_arrow" })
      .to(clearVimPlus()[0])
      .to(clearVimPlus()[1])
      .to(setMode("ins")),

    // A: end of line then insert
    mapFrom("a", "shift")
      .condition(...vimMode("nrm"), opIs("none"))
      .to({ key_code: "end" })
      .to(clearVimPlus()[0])
      .to(clearVimPlus()[1])
      .to(setMode("ins")),

    // o: new line below then insert
    map("o")
      .condition(...vimMode("nrm"), opIs("none"))
      .to({ key_code: "end" })
      .to({ key_code: "return_or_enter" })
      .to(clearVimPlus()[0])
      .to(clearVimPlus()[1])
      .to(setMode("ins")),

    // O: new line above then insert
    mapFrom("o", "shift")
      .condition(...vimMode("nrm"), opIs("none"))
      .to({ key_code: "home" })
      .to({ key_code: "return_or_enter" })
      .to(clearVimPlus()[0])
      .to(clearVimPlus()[1])
      .to(setMode("ins")),
  ]),

  rule("tapped modifiers => actions").manipulators([
    ...TAPPED_MODIFIERS.map(({ from, opts }) => dualRole(from, opts)),
    map("f4").to(FN.HOME_ROW),
  ]),

  rule("held home row => modifiers").manipulators([
    ...HOME_ROW_HELD_MODS.map(({ from, immediateTo, alone, held }) =>
      dualRole(from, {
        immediateTo,
        alone: { key_code: alone },
        heldDown: { key_code: held },
      }),
    ),
  ]),
];

writeToProfile("Default", rules, BASIC_DELAYS);
