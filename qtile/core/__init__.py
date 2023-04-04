"""Core configuration."""

import core.hooks as hooks

from .groups import groups
from .input import wl_input_rules
from .keys import keys
from .layouts import floating_layout, layouts
from .mouse import mouse
from .screens import defaults, screens

widget_defaults = defaults.copy()
extension_defaults = defaults.copy()

__all__ = (
    "extension_defaults",
    "floating_layout",
    "groups",
    "hooks",
    "keys",
    "layouts",
    "mouse",
    "screens",
    "widget_defaults",
    "wl_input_rules",
)
