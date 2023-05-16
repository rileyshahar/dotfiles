"""Groups (workspaces)."""
from libqtile.config import Group, Key
from libqtile.lazy import lazy

from .keys import keys
from .settings import MOD

group_keys = {"": "z", "": "x", "󰭹": "c", **{i: i for i in "123456789"}}

groups = [Group(i) for i in group_keys]


for grp in groups:
    keys.extend(
        [
            # move to group
            Key(
                [MOD],
                group_keys[grp.name],
                lazy.group[grp.name].toscreen(),
                desc=f"switch to group {grp.name}",
            ),
            # move window to group
            Key(
                [MOD, "shift"],
                group_keys[grp.name],
                lazy.window.togroup(grp.name),
                desc=f"move window to {grp.name}",
            ),
        ]
    )
