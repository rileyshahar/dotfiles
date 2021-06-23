#!/bin/sh
background=#a1b26
foreground=#a9b1d6

dim_black=#06080a
dim_red=#e06c75
dim_green=#98c379
dim_yellow=#d19a66
dim_blue=#7aa2f7
dim_magenta=#ad8ee6
dim_cyan=#56bdb8
dim_white=#abb2bf

bright_black=#444b6a
bright_red=#f7768e
bright_green=#9ece6a
bright_yellow=#e0af68
bright_blue=#61afef
bright_magenta=#f6bdff
bright_cyan=#50c3bd
bright_white=#ffffff

# args:
#  1: the filename to modify
#  2: the new string to insert
change_colors() {
  START_MARKER="__colors:start"
  END_MARKET="__color:end"
  # sed script from http://fahdshariff.blogspot.com/2012/12/sed-mutli-line-replacement-between-two.html
  sed -e '/$START_MAKRER/{p;:a;N;/$END_MARKER/!ba;s/.*\n/$2\n/};p' $1
}

read -r -d '' KITTY <<- EOM
  background $background
  foreground $foreground

  # normal
  color0 $dim_black
  color1 $dim_red
  color2 $dim_green
  color3 $dim_yellow
  color4 $dim_blue
  color5 $dim_magenta
  color6 $dim_cyan
  color7 $dim_white

  # bright
  color8 $dim_black
  color9 $dim_red
  color10 $dim_green
  color11 $dim_yellow
  color12 $dim_blue
  color13 $dim_magenta
  color14 $dim_cyan
  color15 $dim_white
EOM

change_colors "$HOME/code/arch-dots/kitty/kitty.conf" $KITTY
