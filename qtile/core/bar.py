"""The bar."""
import subprocess

from libqtile import bar, widget
from libqtile.lazy import lazy
from qtile_extras.widget import Visualizer

from widgets import MyBattery

from .settings import BAR_APPS, COLORS

widgets = bar.Bar(  # type: ignore
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
            mouse_callbacks={"Button1": lazy.spawn(BAR_APPS["cpu"])},
        ),
        widget.Memory(
            fmt=" {}",
            format="{MemPercent:.0f}%",
            foreground=COLORS.BRIGHT_GREEN,
        ),
        # widget.Wlan(
        #     fmt=" {}",
        #     format="{essid} ({percent:2.0%})",
        #     interface="wlp1s0",
        #     foreground=COLORS.BRIGHT_MAGENTA,
        # ),
        widget.Backlight(
            fmt=" {}",
            backlight_name="amdgpu_bl1",
            brightness_file="brightness",
            max_brightness_file="max_brightness",
            foreground=COLORS.BRIGHT_YELLOW,
            update_interval=0.1,
            change_command="brightnessctl set {0}%",
            mouse_callbacks={"Button1": lazy.spawn(BAR_APPS["brightness"])},
            step=1,
            scroll_interval=0.1,
        ),
        widget.GenPollText(
            update_interval=1,
            func=lambda: subprocess.check_output("statusbar-pulse").decode("utf-8"),
            foreground=COLORS.BRIGHT_CYAN,
        ),
        widget.Prompt(),  # XXX: probably not a long-term soln
        widget.Spacer(),
        widget.GenPollText(
            update_interval=1,
            func=lambda: subprocess.check_output("current-track").decode("utf-8").strip(),
            foreground=COLORS.BRIGHT_MAGENTA,
        ),
        widget.Spacer(),
        Visualizer(
            background=COLORS.BACKGROUND,
            bar_colour=COLORS.BRIGHT_CYAN,
            mouse_callbacks={"Button1": lazy.spawn(BAR_APPS["visualizer"])},
        ),
        # widget.GroupBox(
        #     highlight_method="text",
        #     this_current_screen_border=COLORS.DIM_MAGENTA,
        #     active=COLORS.FOREGROUND,
        #     hide_unused=True,
        # ),
        widget.Clock(fmt=" {}", format="%a %Y-%m-%d", foreground=COLORS.BRIGHT_GREEN),
        widget.Clock(fmt=" {}", format="%H:%M:%S", foreground=COLORS.BRIGHT_MAGENTA),
    ],
    size=30,
    background=COLORS.BACKGROUND,
)
