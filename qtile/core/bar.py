"""The bar."""
import subprocess

from libqtile import bar, widget
from libqtile.config import Screen
from libqtile.lazy import lazy

from widgets import MyBattery

from .settings import COLORS, TOP

defaults = {
    "background": COLORS.BACKGROUND,
    "foreground": COLORS.FOREGROUND,
    "font": "MesloLG S Nerd Font",
    "fontsize": 16,
    "padding": 8,
}

screens = [
    Screen(
        bottom=bar.Bar(  # type: ignore
            [
                widget.Chord(
                    name_transform=lambda name: name.upper(),
                    foreground=COLORS.BACKGROUND,
                    background=COLORS.DIM_BLUE,
                ),
                MyBattery(
                    format="{char} {percent:2.0%}",
                    foreground=COLORS.DIM_MAGENTA,
                    low_foreground=COLORS.BRIGHT_RED,
                    low_percentage=0.2,
                ),
                widget.CPU(
                    fmt=" {}",
                    format="{load_percent:.0f}%",
                    foreground=COLORS.BRIGHT_BLUE,
                    mouse_callbacks={"Button1": lazy.spawn(TOP)},
                ),
                widget.Memory(
                    fmt="徭 {}",
                    format="{MemPercent:.0f}%",
                    foreground=COLORS.BRIGHT_YELLOW,
                ),
                widget.GenPollText(
                    fmt=" {}",
                    update_interval=1,
                    func=lambda: subprocess.check_output("statusbar-nvidia").decode(
                        "utf-8"
                    ),
                    foreground=COLORS.BRIGHT_CYAN,
                ),
                widget.Wlan(
                    fmt=" {}",
                    format="{essid} ({percent:2.0%})",
                    interface="wlp0s20f3",
                    foreground=COLORS.BRIGHT_MAGENTA,
                ),
                widget.Prompt(),  # XXX: probably not a long-term soln
                widget.Spacer(),
                widget.GroupBox(
                    highlight_method="text",
                    this_current_screen_border=COLORS.DIM_MAGENTA,
                    active=COLORS.FOREGROUND,
                    hide_unused=True,
                ),
                widget.Spacer(),
                widget.Backlight(
                    fmt=" {}",
                    backlight_name="intel_backlight",
                    foreground=COLORS.BRIGHT_YELLOW,
                    update_interval=0.1,
                    change_command="brightnessctl set {0}%",
                    step=1,
                    scroll_interval=0.1,
                ),
                widget.GenPollText(
                    update_interval=1,
                    func=lambda: subprocess.check_output("statusbar-pulse").decode(
                        "utf-8"
                    ),
                    foreground=COLORS.BRIGHT_CYAN,
                ),
                widget.Clock(
                    fmt=" {}", format="%a %Y-%m-%d", foreground=COLORS.BRIGHT_GREEN
                ),
                widget.Clock(
                    fmt=" {}", format="%H:%M:%S", foreground=COLORS.BRIGHT_MAGENTA
                ),
            ],
            size=24,
            margin=8,
            background=COLORS.BACKGROUND,
        ),
    ),
    Screen(),
]
