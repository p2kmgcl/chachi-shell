#!/usr/bin/env bash

# Walk every file under $CHACHI_OVERRIDES_PATH/home and create a `.local`-
# transformed symlink at the mirrored location under $HOME. Directories are
# never symlinked — only individual files. Parent dirs under $HOME are
# created as needed.
#
# No-op when CHACHI_OVERRIDES_PATH is unset or its home dir is missing.
link_all_overrides() {
  if [ -z "${CHACHI_OVERRIDES_PATH:-}" ]; then
    return 0
  fi

  local root="$CHACHI_OVERRIDES_PATH/home"

  if [ ! -d "$root" ]; then
    return 0
  fi

  local src rel transformed target label existing_link
  while IFS= read -r -d '' src; do
    rel="${src#"$root/"}"
    transformed="$(compute_local_target "$rel")"
    target="$HOME/$transformed"
    label="override $transformed"

    if [ -L "$target" ]; then
      existing_link="$(readlink "$target")"
      if [ "$src" = "$existing_link" ]; then
        echo_success "$label" "already linked"
        continue
      else
        echo_error "$label" "'$target' is already a link to '$existing_link'"
        return 2
      fi
    fi

    if [ -e "$target" ]; then
      echo_error "$label" "'$target' exists as a real file; remove or merge into '$src' manually"
      return 4
    fi

    mkdir -p "$(dirname "$target")"
    ln -s "$src" "$target"
    echo_success "$label" "'$target' → '$src'"
  done < <(find "$root" -type f -print0)
}
