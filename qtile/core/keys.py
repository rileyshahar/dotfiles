"""Keybinds."""
from os import getenv

from libqtile import qtile
from libqtile.config import Key, KeyChord
from libqtile.core.manager import Qtile
from libqtile.lazy import lazy

from .settings import APPS, BAR_APPS, FLOAT_TERM, MOD, TERMINAL

if not qtile or qtile.core.name == "wayland":
    ctrl_keys = [
        # Key(["control"], "h", lazy.layout.left(), desc="left column"),
        # Key(["control"], "j", lazy.layout.down(), desc="next window"),
        # Key(["control"], "k", lazy.layout.up(), desc="previous window"),
        # Key(["control"], "l", lazy.layout.right(), desc="right column"),
    ]
else:
    ctrl_keys = []


def find_edit(mgr: Qtile, cwd: str) -> None:
    """Return a function which edits a file in a floating terminal."""
    mgr.cmd_spawn(f"rofi-find {cwd} 'neovide'")


keys = [
    # toggle floating
    Key([MOD], "t", lazy.window.toggle_floating(), desc="toggle floating"),
    # change focus
    Key([MOD], "h", lazy.layout.left(), desc="left column"),
    Key([MOD], "j", lazy.layout.down(), desc="next window"),
    Key([MOD], "k", lazy.layout.up(), desc="previous window"),
    Key([MOD], "l", lazy.layout.right(), desc="right column"),
    *ctrl_keys,
    # move windows
    Key([MOD, "shift"], "h", lazy.layout.shuffle_left(), desc="move window left"),
    Key([MOD, "shift"], "j", lazy.layout.shuffle_down(), desc="move window down"),
    Key([MOD, "shift"], "k", lazy.layout.shuffle_up(), desc="move window up"),
    Key([MOD, "shift"], "l", lazy.layout.shuffle_right(), desc="move window right"),
    # resize windows
    Key([MOD, "control"], "h", lazy.layout.grow_left(), desc="grow left"),
    Key([MOD, "control"], "j", lazy.layout.grow_down(), desc="grow down"),
    Key([MOD, "control"], "k", lazy.layout.grow_up(), desc="grow up"),
    Key([MOD, "control"], "l", lazy.layout.grow_right(), desc="grow right"),
    Key([MOD, "control"], "r", lazy.layout.normalize(), desc="reset sizes"),
    # move columns
    Key(
        [MOD, "control", "shift"],
        "h",
        lazy.layout.swap_column_left(),
        desc="move column left",
    ),
    Key(
        [MOD, "control", "shift"],
        "l",
        lazy.layout.swap_column_right(),
        desc="move column right",
    ),

    # change screens
    Key([MOD, "shift"], "right", lazy.next_screen(), desc="next screen"),
    Key([MOD, "shift"], "left", lazy.prev_screen(), desc="previous screen"),
    # TODO: up and down?

    # change groups
    Key([MOD], "right", lazy.screen.next_group(skip_empty=True), desc="next group"),
    Key([MOD], "left", lazy.screen.prev_group(skip_empty=True), desc="previous group"),
    Key([MOD], "down", lazy.screen.toggle_group(), desc="toggle group"),
    Key(
        [MOD], "up", lazy.screen.toggle_group(), desc="toggle group"
    ),  # TODO: pick smth else?

    # apps
    *(
        Key([MOD], key, lazy.spawn(app), desc=f"launch {name}")
        for key, app, name in APPS
        if key
    ),
    Key(
        [MOD, "shift"],
        "Return",
        lazy.spawn(FLOAT_TERM),
        desc="floating terminal",
    ),
    # wm controls
    Key([MOD], "Minus", lazy.layout.toggle_split(), desc="toggle column split"),
    Key([MOD], "Semicolon", lazy.next_layout(), desc="toggle layouts"),
    Key([MOD, "shift"], "q", lazy.window.kill(), desc="kill window"),
    Key([MOD, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([MOD, "control", "shift"], "q", lazy.shutdown(), desc="exit qtile"),
    Key([MOD, "shift"], "Space", lazy.spawncmd(), desc="launch the prompt widget"),
    Key([MOD, "shift"], "b", lazy.hide_show_bar(), desc="toggle the bar"),
    # notifications
    Key([MOD], "period", lazy.spawn("dunstctl close"), desc="close top notification"),
    Key(
        [MOD, "shift"],
        "period",
        lazy.spawn("dunstctl close-all"),
        desc="close all notifications",
    ),
    Key(
        [MOD],
        "comma",
        lazy.spawn("dunstctl action 0; dunstctl close"),
        desc="close notification with action",
    ),
    Key(
        [MOD, "shift"],
        "comma",
        lazy.spawn("dunstctl context"),
        desc="open notification context menu",
    ),
    # function keys
    # brightness
    Key(
        [],
        "xF86MonBrightnessUp",
        lazy.spawn("brightnessctl set +5%"),
        desc="raise brightness",
    ),
    Key(
        [],
        "xF86MonBrightnessDown",
        lazy.spawn("brightnessctl set 5%-"),
        desc="lower brightness",
    ),
    # audio
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
        desc="mute audio",
    ),
    Key(
        [],
        "xF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
        desc="lower volume",
    ),
    Key(
        [],
        "xF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
        desc="raise volume",
    ),
    Key(
        [],
        "xF86AudioPlay",
        lazy.spawn("playerctl play-pause"),
        desc="play or pause audio",
    ),
    Key([], "xF86AudioNext", lazy.spawn("playerctl next"), desc="next track"),
    Key([], "xF86AudioPrev", lazy.spawn("playerctl previous"), desc="previous track"),
    # default: whole screen, copy to keyboard
    # mod: custom selection
    # shift: save to file
    Key([], "Print", lazy.spawn("screenshot -s f -o c"), desc="copy full screen"),
    Key([MOD], "Print", lazy.spawn("screenshot -s s -o c"), desc="copy selection"),
    Key(
        ["shift"],
        "Print",
        lazy.spawn("screenshot -s f -o s"),
        desc="save screen to file",
    ),
    Key(
        [MOD, "shift"],
        "Print",
        lazy.spawn("screenshot -s s -o s"),
        desc="save selection to file",
    ),
    # chords
    # KeyChord([MOD], "e", [Key([], "c", lazy.spawn(), desc="edit config")]),
    KeyChord(
        [MOD],
        "b",
        [
            Key([], "c", lazy.spawn(BAR_APPS["cpu"]), desc="spawn top"),
            Key([], "b", lazy.spawn(BAR_APPS["brightness"]), desc="toggle night mode"),
            Key([], "m", lazy.spawn(BAR_APPS["visualizer"]), desc="spawn cava"),
        ],
        name="bar",
    ),
    KeyChord(
        [MOD],
        "o",
        [
            Key([], "o", lazy.spawn("rofi-browser search"), desc="search the web"),
            Key([], "r", lazy.spawn("rofi-rs"), desc="open rust docs"),
            Key(
                [],
                "p",
                lazy.spawn("rofi-find " + getenv("HOME") + ' xdg-open "--type pdf"'),
                desc="open pdfs",
            ),
            Key(
                [],
                "m",
                lazy.spawn("rofi-forester read"),
                desc="open trees",
            ),
            Key(
                [],
                "w",
                lazy.spawn("rofi-browser wiki"),
                desc="open wikipedia",
            ),
            Key(
                [],
                "n",
                lazy.spawn("rofi-browser ncat"),
                desc="open ncatlab",
            ),
        ],
        name="open",
    ),
    KeyChord(
        [MOD],
        "r",
        [
            Key(
                [],
                "r",
                lazy.spawn("rofi-find " + getenv("HOME") + "/library xdg-open"),
                desc="read"
            ),
            Key(
                [],
                "m",
                lazy.spawn("rofi-find " + getenv("HOME") + "/library/math xdg-open"),
                desc="read math books"
            ),
            Key(
                [],
                "f",
                lazy.spawn("rofi-find " + getenv("HOME") + "/library/ffn xdg-open"),
                desc="read fanfic"
            ),
            Key(
                [],
                "s",
                lazy.spawn("rofi-find " + getenv("HOME") + "/library/spec xdg-open"),
                desc="read speculative fiction"
            ),
            Key(
                [],
                "p",
                lazy.spawn("rofi-find " + getenv("HOME") + "/library/papers xdg-open"),
                desc="read papers"
            ),
            Key(
                [],
                "t",
                lazy.spawn("rofi-find " + getenv("HOME") + "/library/ttrpg xdg-open"),
                desc="read ttrpgs"
            ),
        ],
        name="read",
    ),
    KeyChord(
        [MOD],
        "e",
        [
            Key(
                [],
                "n",
                lazy.function(find_edit, getenv("DOTFILES_DIR") + "/nvim"),
                desc="edit neovim config",
            ),
            Key(
                [],
                "c",
                lazy.function(find_edit, getenv("DOTFILES_DIR")),
                desc="edit configs",
            ),
            Key(
                [],
                "m",
                lazy.spawn("rofi-forester edit"),
                desc="edit trees",
            ),
        ],
        name="edit",
    ),
]
