#!/bin/bash

HS=/opt/homebrew/bin/hs

cd "$HOME/media/pics/big/"
open -a Preview $(cat special.txt)
sleep 0.5
"$HS" -c 'exports.fullscreenFrontmost()'

cd "$HOME/media/pics/smol/"
open -a Preview $(cat special.txt)
sleep 0.7
"$HS" -c 'exports.moveFrontmostToLeftHalf()'

cd "$HOME/media/vids/"
open -a "Elmedia Player" *
sleep 0.7
"$HS" -c 'exports.fullscreenFrontmost()'
