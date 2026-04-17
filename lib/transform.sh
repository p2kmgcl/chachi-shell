#!/bin/bash

# Insert `.local` into a path's basename per the migration naming rule.
# Leading `.` on a dotfile counts as part of the basename, not a separator,
# so `.bashrc` -> `.bashrc.local` and `.ssh.config` -> `.ssh.local.config`.
compute_local_target() {
  local path="$1"
  local dir basename stripped before ext

  if [[ "$path" == */* ]]; then
    dir="${path%/*}/"
  else
    dir=""
  fi
  basename="${path##*/}"
  stripped="${basename#.}"

  if [[ "$stripped" == *.* ]]; then
    before="${basename%.*}"
    ext="${basename##*.}"
    echo "${dir}${before}.local.${ext}"
  else
    echo "${dir}${basename}.local"
  fi
}
