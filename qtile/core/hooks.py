"""Hooks."""

import subprocess

from libqtile import hook
from libqtile.backend.base import Window
from libqtile.command.client import InteractiveCommandClient
from libqtile.group import _Group
from libqtile.layout import Stack
from libqtile.layout.base import Layout

from .settings import DAEMONS


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


# @hook.subscribe.layout_change  # type: ignore
# def modify_n_stacks(layout: Layout, group: _Group) -> None:
#     """Modify the number of stacks."""
#     if isinstance(layout, Stack):
#         if len(group.windows) > 1:
#             if len(layout.stacks) == 1:
#                 layout.cmd_add()
#         else:
#             loops = 0
#             while len(layout.stacks) > 1 and loops < 100:
#                 layout.delete_current_stack()  # type: ignore
#                 loops += 1
