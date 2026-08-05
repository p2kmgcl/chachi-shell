#!/usr/bin/env bash

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$THIS_DIR/transform.sh"

assert_eq '.bashrc.local' "$(compute_local_target '.bashrc')" '.bashrc'
assert_eq '.gitconfig.local' "$(compute_local_target '.gitconfig')" '.gitconfig'
assert_eq '.ssh.local.config' "$(compute_local_target '.ssh.config')" '.ssh.config'
assert_eq 'AGENTS.local.md' "$(compute_local_target 'AGENTS.md')" 'AGENTS.md'
assert_eq 'AGENTS.project.local.md' "$(compute_local_target 'AGENTS.project.md')" 'AGENTS.project.md'
assert_eq 'settings.local.json' "$(compute_local_target 'settings.json')" 'settings.json'
assert_eq 'archive.tar.local.gz' "$(compute_local_target 'archive.tar.gz')" 'archive.tar.gz'
assert_eq 'Dockerfile.local' "$(compute_local_target 'Dockerfile')" 'Dockerfile'
assert_eq '.agents/skills/write-code/SKILL.local.md' "$(compute_local_target '.agents/skills/write-code/SKILL.md')" 'path with basename'
