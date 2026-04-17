#!/usr/bin/env bash

# Walk override files under a linked directory entry and create overlay
# symlinks inside the base repo working tree. Because the installed target
# for a directory entry is a symlink to the base subtree, these overlay
# symlinks become visible under $HOME/<dir>/ automatically.
#
# Override source: $CHACHI_OVERRIDES_PATH/home/<thing_name>/<relpath>
# Overlay target:  $CHACHI_PATH/home/<thing_name>/<transformed-relpath>
link_override_subtree() {
  local thing_name="$1"

  if [ -z "${CHACHI_OVERRIDES_PATH:-}" ]; then
    return 0
  fi

  local overrides_subtree="$CHACHI_OVERRIDES_PATH/home/$thing_name"

  if [ ! -d "$overrides_subtree" ]; then
    return 0
  fi

  local override_file rel transformed_rel overlay_path label
  while IFS= read -r -d '' override_file; do
    rel="${override_file#"$overrides_subtree/"}"
    transformed_rel="$(compute_local_target "$rel")"
    overlay_path="$CHACHI_PATH/home/$thing_name/$transformed_rel"
    label="overlay $thing_name/$transformed_rel"

    if [ -L "$overlay_path" ]; then
      local existing_link
      existing_link="$(readlink "$overlay_path")"

      if [ "$override_file" = "$existing_link" ]; then
        echo_success "$label" "already linked"
        continue
      else
        echo_error "$label" "'$overlay_path' is already a link to '$existing_link'"
        return 2
      fi
    fi

    if [ -e "$overlay_path" ]; then
      echo_error "$label" "'$overlay_path' exists as a real file; remove it to proceed"
      return 4
    fi

    mkdir -p "$(dirname "$overlay_path")"
    ln -s "$override_file" "$overlay_path"
    echo_success "$label" "'$overlay_path' → '$override_file'"
  done < <(find "$overrides_subtree" -type f -print0)
}
