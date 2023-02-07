"""Keybinds."""
from libqtile.config import Key, KeyChord
from libqtile.lazy import lazy

from .settings import APPS, MOD, TOP

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
    # change groups
    Key([MOD], "right", lazy.screen.next_group(), desc="next group"),
    Key([MOD], "left", lazy.screen.prev_group(), desc="previous group"),
    Key([MOD], "down", lazy.screen.toggle_group(), desc="toggle group"),
    Key(
        [MOD], "up", lazy.screen.toggle_group(), desc="toggle group"
    ),  # TODO: pick smth else?
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
    Key(
        [MOD, "shift"],
        "Return",
        lazy.spawn("footclient --title=__float"),
        desc="floating terminal",
    ),
    # wm controls
    Key([MOD], "Semicolon", lazy.next_layout(), desc="toggle layouts"),
    Key([MOD, "shift"], "q", lazy.window.kill(), desc="kill window"),
    Key([MOD, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([MOD, "control", "shift"], "q", lazy.shutdown(), desc="exit qtile"),
    Key([MOD, "shift"], "Space", lazy.spawncmd(), desc="launch the prompt widget"),
    # media keys
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
    Key([], "Print", lazy.spawn("grim ~/screenshot.png"), desc="screenshot"),
    # chords
    # KeyChord([MOD], "e", [Key([], "c", lazy.spawn(), desc="edit config")]),
    KeyChord([MOD], "b", [Key([], "c", lazy.spawn(TOP), desc="spawn top")], name="bar"),
]
