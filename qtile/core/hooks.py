"""Hooks."""

import subprocess

from libqtile import hook
from libqtile.backend.base import Window

from .settings import DAEMONS, TRANSPARENT_CLASSES


@hook.subscribe.startup_once  # type: ignore
def start_once() -> None:
    """Start up initial processes."""
    for daemon in DAEMONS:
        subprocess.Popen(daemon.split(" "))


@hook.subscribe.client_new  # type: ignore
def float_class_size(window: Window) -> None:
    """Set the size of our forced-floating windows."""
    if window.name == "__float":
        window.cmd_enable_floating()
        window.cmd_set_size_floating(950, 650)


@hook.subscribe.client_new
def transparency(window: Window) -> None:
    """Set transparency for the correct windows."""
    if any(any(app in c for app in TRANSPARENT_CLASSES) for c in window.get_wm_class()):
        window.cmd_opacity(0.9)
