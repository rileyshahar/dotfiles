"""Easily configured settings."""
from libqtile import qtile

MOD = "MOD4"  # super
# TERMINAL = "kitty -o allow_remote_control=yes --single-instance --listen-on unix:@mykitty"

if not qtile or qtile.core.name == "wayland":  # type: ignore
    TERMINAL = "footclient"
elif qtile.core.name == "x11":  # type: ignore
    TERMINAL = "kitty"

NIGHT_MODE = "pkill -USR1 gammastep"

TOP = "footclient --title=__float btm"
APPS = [
    ("Return", TERMINAL, "terminal"),
    ("Apostrophe", "firefox", "browser"),
    # TODO: built-in prompt?
    ("Space", "launcher", "launcher"),
]

DAEMONS = (
    # f"wbg {WALLPAPER}",
    "foot --server",
    "gammastep",
    "fusuma",
    "anacron -t $HOME/.config/anacron/anacrontab -S $HOME/.local/share/anacron",
    "dunst",
)


class COLORS:
    """The colorscheme."""

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
