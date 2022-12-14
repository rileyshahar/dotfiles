"""Mouse actions configuration."""

from libqtile.config import Click, Drag
from libqtile.lazy import lazy

from .settings import MOD

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
