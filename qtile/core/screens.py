from libqtile.config import Screen

from .bar import widgets
from .settings import COLORS

defaults = {
    "background": COLORS.BACKGROUND,
    "foreground": COLORS.FOREGROUND,
    "font": "MesloLG S Nerd Font",
    "fontsize": 16,
    "padding": 8,
}

screens = [
    Screen(
        wallpaper="~/dotfiles/wallpaper.jpg",
        wallpaper_mode="stretch",
        bottom=widgets,
    ),
    Screen(),
]
