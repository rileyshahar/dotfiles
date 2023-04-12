"""Tiling layouts."""
from libqtile import layout
from libqtile.config import Match

from .settings import COLORS

layout_theme = {
    "border_width": 2,
    "margin": 0,
}

NORMAL_COLOR = COLORS.BRIGHT_BLACK
FOCUS_COLOR = COLORS.DIM_BLUE
STACK_COLOR = COLORS.DIM_MAGENTA

columns_theme = {
    **layout_theme,
    "border_focus": FOCUS_COLOR,
    "border_focus_stack": STACK_COLOR,
    "border_normal": NORMAL_COLOR,
    "border_normal_stack": NORMAL_COLOR,
    "border_on_single": True,
    "split": False,
}

max_theme = {
    **layout_theme,
    "border_focus": STACK_COLOR,
    "border_normal": NORMAL_COLOR,
}

float_theme = {
    **layout_theme,
    "border_normal": NORMAL_COLOR,
    "border_focus": FOCUS_COLOR,
}


layouts = [
    layout.Columns(**columns_theme),  # type: ignore
    layout.Max(**max_theme),  # type: ignore
]

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirm"),
        Match(wm_class="dialog"),
        Match(wm_class="download"),
        Match(wm_class="error"),
        Match(wm_class="file_progress"),
        Match(wm_class="notification"),
        Match(wm_class="splash"),
        Match(wm_class="toolbar"),
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        # Match(title="__float"),  # things we ask to float
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ],
    **float_theme,
)
