"""Hooks."""

import subprocess

from libqtile import hook
from libqtile.backend.base import Window
from libqtile.utils import send_notification

from .settings import DAEMONS, TRANSPARENT_CLASSES


@hook.subscribe.startup_once  # type: ignore
def start_once() -> None:
    """Start up initial processes."""
    for daemon in DAEMONS:
        subprocess.Popen(daemon.split(" "))


def _should_float(window: Window) -> bool:
    """Check whether a window should float."""
    return window.name == "__float"


# @hook.subscribe.client_new  # type: ignore
# def new_client(window: Window) -> None:
#     """Set transparency and floats for the correct windows."""
#     if any(any(app in c for app in TRANSPARENT_CLASSES) for c in window.get_wm_class()):
#         # TODO: broken by new qtile update
#         window.set_opacity(0.8)

#     if _should_float(window):
#         window.enable_floating()
#         window.set_size_floating(950, 650)
#         window.set_opacity(1.0)
