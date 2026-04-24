#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Fish Zed
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📝
# @raycast.packageName me.pablomolina.fish.zed

# Documentation:
# @raycast.description Open Zed with fish environment
# @raycast.author pablo_molina
# @raycast.authorURL https://raycast.com/pablo_molina

target="${1:-$HOME}"
exec /opt/homebrew/bin/fish -l -c "zed '$target'"
