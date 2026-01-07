#!/opt/homebrew/bin/fish

# @raycast.schemaVersion 1
# @raycast.title Open Media
# @raycast.mode silent
# @raycast.packageName Custom

set HS hs

cd "$HOME/media/pics/big/"
open -a Preview (cat special.txt)
sleep 0.5
$HS -c 'exports.fullscreenFrontmost()'

cd "$HOME/media/pics/smol/"
open -a Preview (cat special.txt)
sleep 0.7
$HS -c 'exports.moveFrontmostToLeftHalf()'

cd "$HOME/media/vids/"
open -a "Elmedia Player" *
sleep 0.7
$HS -c 'exports.fullscreenFrontmost()'
