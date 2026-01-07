// f15 -- homerow
// f16 -- raycast
// f17 -- raycast kagi
// f18 -- leaderkey

import {
  FromKeyParam,
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
 *  Vars / Modes
 *  ----------------------------- */
const VAR = {
  MODE: "mode",
  TEXT_INPUT: "in_text_input",
} as const;

enum Mode {
  app = "app",
  ins = "ins",
  nrm = "nrm",
  vis = "vis",
  ign = "ign",
}

const ModeValue = {
  app: 0,
  ins: 1,
  nrm: 2,
  vis: 3,
  ign: 4,
};

const BypassApps = ["com.neovide.neovide", "org.mozilla.firefox"];

const hs = (lua: string) => `/opt/homebrew/bin/hs -c "${lua}"`;
const setMode = (m: Mode) => to$(hs(`setMode('${m}')`));

const modeIs = (m: Mode) => ifVar(VAR.MODE, ModeValue[m]);
const vimOff = modeIs(Mode.ign);
const vimOn = vimOff.unless();
const vimActive = [
  vimOn,
  ...BypassApps.map((a) => ifApp(a).unless()),
];

/** -----------------------------
 *  Small building blocks
 *  ----------------------------- */

// Adds halt:true to avoid double-firing alongside to_delayed_action
const haltKey = (key_code: ToKeyCode, modifiers?: Modifier[]) =>
  ({ key_code, modifiers, halt: true }) as const;

const transition = (
  key: FromKeyParam,
  from: Mode | Mode[],
  to: Mode,
) =>
  (Array.isArray(from) ? from : [from]).map((m) =>
    map(key)
      .condition(...vimActive, modeIs(m))
      .to(setMode(to))
  );

type DualRoleOpts = {
  fromMods?: Parameters<typeof map>[1];
  /** Optional immediate "to" (keeps your tab/caps behavior exactly) */
  immediateTo?: ToEvent;
  alone: { key_code: ToKeyCode; mods?: Modifier[] };
  heldDown: ToEvent;
};

const dualRole = (fromKey: FromKeyParam, opts: DualRoleOpts) => {
  const fromMods = opts.fromMods ?? "optionalAny";
  const alone = haltKey(opts.alone.key_code, opts.alone.mods);

  let m = map(fromKey, fromMods);
  if (opts.immediateTo) m = m.to(opts.immediateTo);

  return m
    .toIfAlone(alone)
    .toIfHeldDown(opts.heldDown)
    .toDelayedAction([], [alone]);
};

/** -----------------------------
 *  Navigation mappings
 *  ----------------------------- */
const arrowOf = {
  h: "left_arrow",
  j: "down_arrow",
  k: "up_arrow",
  l: "right_arrow",
} as const;

const keysOf = <T extends Record<string, unknown>>(obj: T) =>
  Object.keys(obj) as Array<keyof T>;

function hjkl(mode: Mode, mods?: Modifier[]) {
  return keysOf(arrowOf).map((k) =>
    map(k)
      .condition(...vimActive, modeIs(mode))
      .to({ key_code: arrowOf[k], modifiers: mods })
  );
}

function wordNav(mode: Mode) {
  return [
    map("e")
      .condition(...vimActive, modeIs(mode))
      .to({ key_code: "right_arrow", modifiers: ["left_option"] }),
    map("b")
      .condition(...vimActive, modeIs(mode))
      .to({ key_code: "left_arrow", modifiers: ["left_option"] }),
  ];
}

/** -----------------------------
 *  Global / Profile
 *  ----------------------------- */
writeToGlobal({
  show_in_menu_bar: false,
  show_profile_name_in_menu_bar: true,
});

/** -----------------------------
 *  Rules
 *  ----------------------------- */
const rules = [
  rule("[vim] toggle modes").manipulators([
    // F3 toggles vim
    map("f3")
      .condition(vimOff)
      .to(setMode(Mode.ins)),

    map("f3")
      .condition(vimOn)
      .to(setMode(Mode.ign)),

    // ESC -> Normal from ins/vis/app
    ...transition("escape", [Mode.ins, Mode.vis, Mode.app], Mode.nrm),

    // i/v/a from Normal
    ...transition("i", Mode.nrm, Mode.ins),
    ...transition("v", Mode.nrm, Mode.vis),
    ...transition("a", Mode.nrm, Mode.app),
  ]),

  rule("[vim] movement").manipulators([
    ...hjkl(Mode.nrm),
    ...hjkl(Mode.app),
    ...hjkl(Mode.vis, ["left_shift"]), // selection
    ...wordNav(Mode.nrm),
    ...wordNav(Mode.app),
    // map("f", "optionalAny")
    //   .condition(...vimActive, modeIs(Mode.app))
    //   .to("f15"),
  ]),

  rule("[vim] apple mail (app only)").manipulators([
    map("a", "optionalAny")
      .condition(ifApp("^com\\.apple\\.mail$"), ...vimActive, modeIs(Mode.app))
      .to({ key_code: "a", modifiers: ["left_command", "left_control"] }),
    map("f", "optionalAny")
      .condition(ifApp("^com\\.apple\\.mail$"), ...vimActive, modeIs(Mode.app))
      .to({ key_code: "f", modifiers: ["left_command", "left_shift"] }),
    map("r", "optionalAny")
      .condition(ifApp("^com\\.apple\\.mail$"), ...vimActive, modeIs(Mode.app))
      .to({ key_code: "r", modifiers: ["left_command", "left_shift"] }),
  ]),

  // rule("[vim] Preview.app (app only) zathura-style").manipulators([
  //   // gg / G: first / last (beginning/end of document)
  //   mapDoubleTap("g", 250)
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .singleTap(null)
  //     .to(haltKey("home")),
  //   map("g", ["left_shift"])
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("end")),
  //
  //   // J / K: next / previous page
  //   map("j", ["left_shift"])
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("down_arrow", ["left_option"])),
  //   map("k", ["left_shift"])
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("up_arrow", ["left_option"])),
  //
  //   // tab + sidebar (table of contents / thumbnails / notes / bookmarks)
  //   // tab keeps your global "tab-as-cmd" behavior: hold = ⌘, tap = TOC
  //   map("tab")
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to({ key_code: "left_command" })
  //     .toIfAlone(haltKey("3", ["left_option", "left_command"]))
  //     .toIfHeldDown({ key_code: "left_command" })
  //     .toDelayedAction([], [haltKey("3", ["left_option", "left_command"])]),
  //   // Shift-Tab: hide sidebar
  //   map("tab", ["left_shift"])
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("1", ["left_option", "left_command"])),
  //   // t: thumbnails, T: table of contents
  //   map("t")
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("2", ["left_option", "left_command"])),
  //   map("t", ["left_shift"])
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("3", ["left_option", "left_command"])),
  //   // H: highlights & notes, B: bookmarks
  //   map("h", ["left_shift"])
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("4", ["left_option", "left_command"])),
  //   map("b", ["left_shift"])
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("5", ["left_option", "left_command"])),
  //   // c: contact sheet view
  //   map("c")
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("6", ["left_option", "left_command"])),
  //
  //   // a / +/-/=: fit / zoom in/out / actual size
  //   map("a")
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("9", ["left_option", "left_command"])),
  //   map("equal_sign", ["left_shift"])
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to({
  //       key_code: "equal_sign",
  //       modifiers: ["left_option", "left_command", "left_shift"],
  //       halt: true,
  //     }),
  //   map("hyphen")
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to({
  //       key_code: "hyphen",
  //       modifiers: ["left_option", "left_command"],
  //       halt: true,
  //     }),
  //   map("equal_sign")
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("0", ["left_option", "left_command"])),
  //
  //   // / n N: find / next / previous
  //   map("slash")
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("f", ["left_command"])),
  //   map("n")
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("g", ["left_command"])),
  //   map("n", ["left_shift"])
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("g", ["left_command", "left_shift"])),
  //
  //   // R: rotate 90° (clockwise)
  //   map("r", ["left_shift"])
  //     .condition(ifApp("^com\\.apple\\.Preview$"), vimOn, modeIs(Mode.app))
  //     .to(haltKey("r", ["left_command"])),
  // ]),

  rule("tapped modifiers => actions").manipulators([
    dualRole("left_command", {
      alone: { key_code: "f18" },
      heldDown: { key_code: "left_command" },
    }),

    dualRole("right_command", {
      alone: { key_code: "f16" },
      heldDown: { key_code: "right_command" },
    }),

    dualRole("right_option", {
      alone: { key_code: "f17" },
      heldDown: { key_code: "right_option" },
    }),

    map("f4").to("f15"),
  ]),

  rule("held home row => modifiers").manipulators([
    // tab: immediate cmd when held, tab when alone
    dualRole("tab", {
      immediateTo: { key_code: "left_command" },
      alone: { key_code: "tab" },
      heldDown: { key_code: "left_command" },
    }),

    // caps_lock: immediate ctrl when held, esc when alone
    dualRole("caps_lock", {
      immediateTo: { key_code: "left_control" },
      alone: { key_code: "escape" },
      heldDown: { key_code: "left_control" },
    }),

    // home row mods (held-only)
    dualRole("a", {
      alone: { key_code: "a" },
      heldDown: { key_code: "left_shift" },
    }),
    dualRole("s", {
      alone: { key_code: "s" },
      heldDown: { key_code: "left_control" },
    }),
    dualRole("d", {
      alone: { key_code: "d" },
      heldDown: { key_code: "left_option" },
    }),
    dualRole("f", {
      alone: { key_code: "f" },
      heldDown: { key_code: "left_command" },
    }),
  ]),
];

writeToProfile("Default", rules, {
  "basic.to_delayed_action_delay_milliseconds": 150,
  "basic.to_if_alone_timeout_milliseconds": 150,
  "basic.to_if_held_down_threshold_milliseconds": 150,
});
