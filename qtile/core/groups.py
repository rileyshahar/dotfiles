"""Groups (workspaces)."""
from libqtile.config import Group, Key
from libqtile.lazy import lazy

from .keys import keys
from .settings import MOD
from .layouts import vertical_layout

group_keys = {"": "z", "": "x", "󰭹": "c", **{i: i for i in "123456789"}}

groups = [Group(i) for i in group_keys] + [Group("tall", screen_affinity=2, layouts=[vertical_layout])]


for grp in groups[:-1]:
    keys.extend(
        [
            # move to group
            Key(
                [MOD],
                group_keys[grp.name],
                lazy.group[grp.name].toscreen(),
                desc=f"switch to group {grp.name}",
            ),
            Key(
                [MOD],
                "t",
                lazy.group["tall"].toscreen(),
                desc=f"switch to group tall",
            ),
            # move window to group
            Key(
                [MOD, "shift"],
                group_keys[grp.name],
                lazy.window.togroup(grp.name),
                desc=f"move window to {grp.name}",
            ),
            Key(
                [MOD, "shift"],
                "t",
                lazy.window.togroup("tall"),
                desc=f"move window to tall",
            ),
        ]
    )
