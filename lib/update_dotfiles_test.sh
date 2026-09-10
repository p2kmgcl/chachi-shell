#!/usr/bin/env bash

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$THIS_DIR/.." && pwd)"

test_links_pi_files_into_existing_agent_directory() {
  local home_dir agents_source agents_target settings_source settings_target
  home_dir="$(mktemp -d)"
  agents_source="$REPO_DIR/home/.pi/agent/AGENTS.md"
  agents_target="$home_dir/.pi/agent/AGENTS.md"
  settings_source="$REPO_DIR/home/.pi/agent/settings.json"
  settings_target="$home_dir/.pi/agent/settings.json"

  mkdir -p "$home_dir/.pi/agent"
  HOME="$home_dir" \
    CHACHI_PATH="$REPO_DIR" \
    CHACHI_OVERRIDES_PATH= \
    bash "$REPO_DIR/update_dotfiles.sh" >/dev/null

  assert_eq "$agents_source" "$(readlink "$agents_target")" 'pi agents linked'
  assert_eq "$settings_source" "$(readlink "$settings_target")" 'pi settings linked'
  assert_eq 'directory' "$([ -d "$home_dir/.pi/agent" ] && [ ! -L "$home_dir/.pi/agent" ] && printf directory)" 'pi agent directory remains real'

  rm -rf "$home_dir"
}

test_links_pi_files_into_existing_agent_directory
