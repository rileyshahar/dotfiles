#!/usr/bin/env python
#
# cac: adjust colorschemes automatically

import argparse
import os
import json


START_MARKER = "__colors:start"
END_MARKER = "__colors:end"

CONFIG_HOME = os.getenv(
    "XDG_CONFIG_HOME", default=f"{os.getenv('HOME')}/.config")

parser = argparse.ArgumentParser(description="cac adjusts colorschemes:\
    download a colorscheme JSON from https://terminal.sexy, place it in\
    $XDG_CONFIG_HOME/cac, and run cac.")
parser.add_argument(
    "scheme",
    default=None,
    help="the name of a colorscheme in $XDG_CONFIG_HOME/cac",
)
args = parser.parse_args()

colors = {}
scheme_loc = CONFIG_HOME + "/cac/" + args.scheme + ".json"
try:
    scheme = json.load(open(scheme_loc))
except FileNotFoundError:
    print(f"No colorscheme found at {scheme_loc}.")
    quit(1)

colors["background"] = scheme["background"][1:]
colors["foreground"] = scheme["foreground"][1:]
colors["dim_black"] = scheme["color"][0][1:]
colors["dim_red"] = scheme["color"][1][1:]
colors["dim_green"] = scheme["color"][2][1:]
colors["dim_yellow"] = scheme["color"][3][1:]
colors["dim_blue"] = scheme["color"][4][1:]
colors["dim_magenta"] = scheme["color"][5][1:]
colors["dim_cyan"] = scheme["color"][6][1:]
colors["dim_white"] = scheme["color"][7][1:]
colors["bright_black"] = scheme["color"][8][1:]
colors["bright_red"] = scheme["color"][9][1:]
colors["bright_green"] = scheme["color"][10][1:]
colors["bright_yellow"] = scheme["color"][11][1:]
colors["bright_blue"] = scheme["color"][12][1:]
colors["bright_magenta"] = scheme["color"][13][1:]
colors["bright_cyan"] = scheme["color"][14][1:]
colors["bright_white"] = scheme["color"][15][1:]


class ColorFormatter:

    color_names = {}
    color_fmt = ""
    config_file = ""

    @classmethod
    def change_colors(cls):
        """Change the colors of `file`.

        names is be a dictionary mapping the names used in colors to the names
            to be used in the file.

        colorfmt is an fstring which may use the following variables:
            name: the name of the color, according to names
            col_hex: the color's hex
        """

        out = ""
        with open(cls.config_file, "r") as f:
            while (line := f.readline()) and START_MARKER not in line:
                out = out + line
            if not line:
                return False
            out = out + line
            out = out + cls.process_colorfmt()
            while END_MARKER not in (line := f.readline()):
                pass
            out = out + line
            while (line := f.readline()):
                out = out + line
        with open(cls.config_file, "w") as f:
            f.write(out)
        return True

    @classmethod
    def process_colorfmt(cls):
        out = ""
        for name, col_hex in colors.items():
            out = out + \
                cls.color_fmt.format(
                    name=cls.color_names[name], col_hex=col_hex) + "\n"
        return out

    def __init_subclass__(cls):
        success = cls.change_colors()
        if success:
            cls.post_format_hook()
            print(f"{cls.__name__} formatted successfully")
        else:
            print(f"{cls.__name__} could not be formatted."
                  f" perhaps the start marker is missing: {START_MARKER}")

    @classmethod
    def post_format_hook(cls):
        pass


# a helpful set of names which use the ansi number
NUMBERED_COLOR_NAMES = {
    "background": "background",
    "foreground": "foreground",
    "dim_black": "color0",
    "dim_red": "color1",
    "dim_green": "color2",
    "dim_yellow": "color3",
    "dim_blue": "color4",
    "dim_magenta": "color5",
    "dim_cyan": "color6",
    "dim_white": "color7",
    "bright_black": "color8",
    "bright_red": "color9",
    "bright_green": "color10",
    "bright_yellow": "color11",
    "bright_blue": "color12",
    "bright_magenta": "color13",
    "bright_cyan": "color14",
    "bright_white": "color15",
}


class Kitty(ColorFormatter):

    color_fmt = "{name} #{col_hex}"
    config_file = CONFIG_HOME + "/kitty/kitty.conf"
    color_names = NUMBERED_COLOR_NAMES

    @classmethod
    def post_format_hook(cls):
        os.system(f"kitty @ set-colors --all --configured {cls.config_file}")


class XResources(ColorFormatter):

    color_fmt = "*{name}: #{col_hex}"
    config_file = CONFIG_HOME + "/X11/xresources"
    color_names = NUMBERED_COLOR_NAMES

    @classmethod
    def post_format_hook(cls):
        os.system(f"xrdb {cls.config_file}")