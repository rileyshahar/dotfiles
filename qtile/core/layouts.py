"""Tiling layouts."""
from libqtile import layout
from libqtile.config import Match

from .settings import COLORS

layout_theme = {
    "border_width": 2,
    "margin": 8,
    "border_focus": COLORS.DIM_MAGENTA,
    "border_normal": COLORS.BRIGHT_BLACK,
}


layouts = [
    layout.MonadTall(**layout_theme),  # type: ignore
    layout.Max(**layout_theme),  # type: ignore
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
    **layout_theme,
)
