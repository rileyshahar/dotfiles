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
  fromMods?: FromModifierParam | "";
  /** Optional immediate "to" (keeps your tab/caps behavior exactly) */
  immediateTo?: ToEvent;
  alone: { key_code: ToKeyCode; mods?: Modifier[] };
  heldDown: ToEvent;
};

const dualRole = (fromKey: FromKeyParam, opts: DualRoleOpts) => {
  const alone = haltKey(opts.alone.key_code, opts.alone.mods);

  let m = opts.fromMods
    ? map(fromKey, opts.fromMods)
    : map(fromKey, "optionalAny");
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

const process = (from: FromKeyParam, m: FromModifierParam | "" | undefined) => {
  if (m == undefined) {
    return map(from, "optionalAny");
  } else if (m == "") {
    return map(from);
  } else {
    return map(from, m);
  }
};

const appConfig = (name: string, app: string, keys: KeySpec[]) => {
  return rule(`[vim] ${name} (app only)`).manipulators(
    keys.map((ks) =>
      process(ks.from, ks.fromMods).condition(
        ifApp(app),
        ...vimActive,
        modeIs(Mode.app),
      ).to(ks.to)
    ),
  );
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

  appConfig("apple mail", "com.apple.mail", [
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
  ]),

  // appConfig("preview", "com.apple.preview", [
  //   {
  //     from: "j",
  //     fromMods: "",
  //     to: { key_code: "down_arrow" },
  //   },
  //   {
  //     from: "k",
  //     fromMods: "",
  //     to: { key_code: "up_arrow" },
  //   },
  //   {
  //     from: "h",
  //     fromMods: "",
  //     to: { key_code: "left_arrow" },
  //   },
  //   {
  //     from: "l",
  //     fromMods: "",
  //     to: { key_code: "right_arrow" },
  //   },
  //
  //   // zathura: J/K = next/prev page
  //   // {
  //   //   from: "J",
  //   //   to: { key_code: "down_arrow", modifiers: ["left_option"] },
  //   // },
  //   // {
  //   //   from: "K",
  //   //   to: { key_code: "up_arrow", modifiers: ["left_option"] },
  //   // },
  //
  //   // zathura: space / b = page down / page up
  //   {
  //     from: "spacebar",
  //     to: { key_code: "page_down" },
  //   },
  //   {
  //     from: "b",
  //     to: { key_code: "page_up" },
  //   },
  //
  //   // zathura: d/u are half-page by default; Preview doesn’t have a clean half-page shortcut,
  //   // so approximate with screen-at-a-time
  //   {
  //     from: "d",
  //     to: { key_code: "page_down" },
  //   },
  //   {
  //     from: "u",
  //     to: { key_code: "page_up" },
  //   },
  //
  //   // zathura: gg / G = first / last page (best-effort)
  //   // {
  //   //   from: "gg",
  //   //   to: { key_code: "home" },
  //   // },
  //   // {
  //   //   from: "G",
  //   //   to: { key_code: "end" },
  //   // },
  //
  //   // zathura: g (and nG) to jump — map to Preview “Go to Page…”
  //   {
  //     from: "g",
  //     to: { key_code: "g", modifiers: ["left_option", "left_command"] },
  //   },
  //
  //   // zathura: + / - / a / s
  //   // zoom in/out (Cmd-+ / Cmd--), best-fit (Cmd-9), “width mode” approximation = continuous scroll (Cmd-1)
  //   {
  //     from: "=",
  //     fromMods: "shift",
  //     to: { key_code: "equal_sign", modifiers: ["left_shift", "left_command"] }, // Cmd-+
  //   },
  //   {
  //     from: "-",
  //     to: { key_code: "hyphen", modifiers: ["left_command"] }, // Cmd--
  //   },
  //   {
  //     from: "a",
  //     to: { key_code: "9", modifiers: ["left_command"] }, // Cmd-9 (Zoom to Fit)
  //   },
  //   {
  //     from: "s",
  //     to: { key_code: "1", modifiers: ["left_command"] }, // Cmd-1 (Continuous Scroll view)
  //   },
  //   {
  //     from: "=",
  //     to: { key_code: "0", modifiers: ["left_command"] }, // Cmd-0 (Actual Size / “reset-ish”)
  //   },
  //
  //   // zathura: r = rotate (Preview uses Cmd-R / Cmd-L)
  //   {
  //     from: "r",
  //     to: { key_code: "r", modifiers: ["left_command"] }, // rotate clockwise
  //   },
  //   {
  //     from: "R",
  //     to: { key_code: "l", modifiers: ["left_command"] }, // rotate counterclockwise (extra)
  //   },
  //
  //   // zathura: /, n, N = search / next / previous
  //   {
  //     from: "/",
  //     to: { key_code: "f", modifiers: ["left_command"] }, // Find
  //   },
  //   {
  //     from: "n",
  //     to: { key_code: "g", modifiers: ["left_command"] }, // Find Next
  //   },
  //   {
  //     from: "N",
  //     to: { key_code: "g", modifiers: ["left_shift", "left_command"] }, // Find Previous
  //   },
  //
  //   // zathura: Tab = index — map to Preview thumbnails sidebar
  //   {
  //     from: "tab",
  //     to: { key_code: "2", modifiers: ["left_option", "left_command"] },
  //   },
  //
  //   // open / close / quit
  //   {
  //     from: "o",
  //     to: { key_code: "o", modifiers: ["left_command"] },
  //   },
  //   {
  //     from: "q",
  //     to: { key_code: "w", modifiers: ["left_command"] }, // close document window (safer zathura-like quit)
  //   },
  //   {
  //     from: "Q",
  //     to: { key_code: "q", modifiers: ["left_command"] }, // quit Preview.app (optional)
  //   },
  //
  //   // fullscreen toggle (handy)
  //   {
  //     from: "f",
  //     to: { key_code: "f", modifiers: ["left_control", "left_command"] },
  //   },
  // ]),

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
