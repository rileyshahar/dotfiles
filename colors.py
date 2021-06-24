#!/bin/env/python

import os
import json

START_MARKER = "__colors:start"
END_MARKER = "__colors:end"

# set JSON_STRING to a json string from https://terminal.sexy/
USE_JSON = False
JSON_STRING = ""

if USE_JSON:
    COLORS = {}
    js = json.loads(JSON_STRING)
    COLORS["background"] = js["background"][1:]
    COLORS["foreground"] = js["foreground"][1:]
    COLORS["dim_black"] = js["color"][0][1:]
    COLORS["dim_red"] = js["color"][1][1:]
    COLORS["dim_green"] = js["color"][2][1:]
    COLORS["dim_yellow"] = js["color"][3][1:]
    COLORS["dim_blue"] = js["color"][4][1:]
    COLORS["dim_magenta"] = js["color"][5][1:]
    COLORS["dim_cyan"] = js["color"][6][1:]
    COLORS["dim_white"] = js["color"][7][1:]
    COLORS["bright_black"] = js["color"][8][1:]
    COLORS["bright_red"] = js["color"][9][1:]
    COLORS["bright_green"] = js["color"][10][1:]
    COLORS["bright_yellow"] = js["color"][11][1:]
    COLORS["bright_blue"] = js["color"][12][1:]
    COLORS["bright_magenta"] = js["color"][13][1:]
    COLORS["bright_cyan"] = js["color"][14][1:]
    COLORS["bright_white"] = js["color"][15][1:]
else:
    COLORS = {
        "background": "1a1b26",
        "foreground": "a9b1d6",
        "dim_black": "06080a",
        "dim_red": "e06c75",
        "dim_green": "98c379",
        "dim_yellow": "d19a66",
        "dim_blue": "7aa2f7",
        "dim_magenta": "ad8ee6",
        "dim_cyan": "56bdb8",
        "dim_white": "abb2bf",
        "bright_black": "444b6a",
        "bright_red": "f7768e",
        "bright_green": "9ece6a",
        "bright_yellow": "e0af68",
        "bright_blue": "61afef",
        "bright_magenta": "f6bdff",
        "bright_cyan": "50c3bd",
        "bright_white": "ffffff",
    }


class ColorFormatter:

    color_names = {}
    color_fmt = ""
    config_file = ""

    @classmethod
    def change_colors(cls):
        """Change the colors of `file`.

        names is be a dictionary mapping the names used in COLORS to the names
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
        for name, col_hex in COLORS.items():
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
    config_file = "kitty/kitty.conf"
    color_names = NUMBERED_COLOR_NAMES

    @classmethod
    def post_format_hook(cls):
        os.system(f"kitty @ set-colors --all --configured {cls.config_file}")


class XResources(ColorFormatter):

    color_fmt = "*{name}: #{col_hex}"
    config_file = "X11/xresources"
    color_names = NUMBERED_COLOR_NAMES

    @classmethod
    def post_format_hook(cls):
        os.system(f"xrdb {cls.config_file}")
