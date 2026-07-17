#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Download YouTube as MKV
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🎬
# @raycast.argument1 { "type": "text", "placeholder": "YouTube URL" }
# @raycast.packageName YouTube Tools

# Documentation:
# @raycast.description Download a YouTube video as MKV in the highest quality available.
# @raycast.author you

# Ensure common install locations are on PATH (Raycast uses a minimal env)
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"

yt-dlp -f "bv*+ba/b" --cookies-from-browser firefox --merge-output-format mkv -P "$HOME/Downloads" "$1"
