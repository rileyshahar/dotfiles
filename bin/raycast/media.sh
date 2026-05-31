#!/bin/bash

IMPL=$HOME/dotfiles/bin/raycast/open-media-impl.sh

# @raycast.schemaVersion 1
# @raycast.title Open Media
# @raycast.mode silent
# @raycast.packageName Custom

(nohup /bin/bash $IMPL </dev/null >/tmp/media.log 2>&1 &)
