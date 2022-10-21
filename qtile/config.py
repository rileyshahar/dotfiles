import subprocess

from libqtile import bar, hook, layout, widget
from libqtile.backend.wayland import InputConfig
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy

MOD = "MOD4"  # super
# TERMINAL = "kitty -o allow_remote_control=yes --single-instance --listen-on unix:@mykitty"
TERMINAL = "footclient"
APPS = [
    ("Return", TERMINAL, "terminal"),
    ("Apostrophe", "firefox", "browser"),
    # TODO: built-in prompt?
    ("Space", "launcher", "launcher"),
]

DAEMONS = (
    # f"wbg {WALLPAPER}",
    "foot --server",
)


# __cac:start
BACKGROUND = "1a1b26"
FOREGROUND = "a9b1d6"
DIM_BLACK = "06080a"
DIM_RED = "e06c75"
DIM_GREEN = "98c379"
DIM_YELLOW = "d19a66"
DIM_BLUE = "7aa2f7"
DIM_MAGENTA = "ad8ee6"
DIM_CYAN = "56bdb8"
DIM_WHITE = "545a75"
BRIGHT_BLACK = "24283b"
BRIGHT_RED = "f7768e"
BRIGHT_GREEN = "9ece6a"
BRIGHT_YELLOW = "e0af68"
BRIGHT_BLUE = "61afef"
BRIGHT_MAGENTA = "f6bdff"
BRIGHT_CYAN = "50c3bd"
BRIGHT_WHITE = "a9b1d6"
# __cac:end

keys = [
    # change focus
    Key([MOD], "h", lazy.layout.left(), desc="focus left"),
    Key([MOD], "l", lazy.layout.right(), desc="focus right"),
    Key([MOD], "j", lazy.layout.down(), desc="focus down"),
    Key([MOD], "k", lazy.layout.up(), desc="focus up"),
    Key(["control"], "h", lazy.layout.left(), desc="focus left"),
    Key(["control"], "l", lazy.layout.right(), desc="focus right"),
    Key(["control"], "j", lazy.layout.down(), desc="focus down"),
    Key(["control"], "k", lazy.layout.up(), desc="focus up"),
    # move windows
    Key([MOD, "shift"], "h", lazy.layout.shuffle_left(), desc="move window left"),
    Key([MOD, "shift"], "l", lazy.layout.shuffle_right(), desc="move window right"),
    Key([MOD, "shift"], "j", lazy.layout.shuffle_down(), desc="move window down"),
    Key([MOD, "shift"], "k", lazy.layout.shuffle_up(), desc="move window up"),
    # resize windows
    Key([MOD, "control"], "k", lazy.layout.grow(), desc="grow window"),
    Key([MOD, "control"], "j", lazy.layout.shrink(), desc="shrink window"),
    Key([MOD, "control"], "r", lazy.layout.reset(), desc="reset sizes"),
    # apps
    *(
        Key([MOD], key, lazy.spawn(app), desc=f"launch {name}")
        for key, app, name in APPS
    ),
    # wm controls
    Key([MOD], "Semicolon", lazy.next_layout(), desc="toggle layouts"),
    Key([MOD, "shift"], "q", lazy.window.kill(), desc="kill window"),
    Key([MOD, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([MOD, "control", "shift"], "q", lazy.shutdown()),
]

group_keys = {"": "z", "": "x", "": "c", **{i: i for i in "123456789"}}

groups = [Group(i) for i in group_keys]


for grp in groups:
    keys.extend(
        [
            # move to group
            Key(
                [MOD],
                group_keys[grp.name],
                lazy.group[grp.name].toscreen(),
                desc=f"switch to group {grp.name}",
            ),
            # move window to group
            Key(
                [MOD, "shift"],
                group_keys[grp.name],
                lazy.window.togroup(grp.name),
                desc=f"move window to {grp.name}",
            ),
        ]
    )

layout_theme = {
    "border_width": 2,
    "margin": 8,
    "border_focus": DIM_MAGENTA,
    "border_normal": BRIGHT_BLACK,
}


layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                widget.QuickExit(),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

mouse = [
    Drag(
        [MOD],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [MOD], "Button2", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([MOD], "Button3", lazy.window.bring_to_front()),
]

bring_front_click = "floating_only"
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(title="pinentry"),  # GPG key password entry
    ]
)
cursor_warp = False
auto_fullscreen = True

wl_input_rules = {
    "type:keyboard": InputConfig(kb_options="ctrl:nocaps,altwin:swap_alt_win"),
    "type:touchpad": InputConfig(
        natural_scroll=True, middle_emulation=True, click_method="clickfinger"
    ),
}


@hook.subscribe.startup_once
def start_once():
    for daemon in DAEMONS:
        subprocess.Popen(daemon.split(" "))
