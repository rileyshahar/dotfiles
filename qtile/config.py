"""Qtile config."""
from core import (
    floating_layout,
    groups,
    hooks,
    keys,
    layouts,
    mouse,
    screens,
    widget_defaults,
    wl_input_rules,
)

auto_fullscreen = True
auto_minimize = False
bring_front_click = "floating_only"
cursor_warp = False
dgroups_key_binder = None
follow_mouse_focus = True
focus_on_window_activation = "smart"
reconfigure_screens = True
wmname = "qtile"
