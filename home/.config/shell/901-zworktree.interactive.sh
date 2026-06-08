zworktree() {
  local worktrees
  worktrees=$(git worktree list --porcelain 2>/dev/null | grep '^worktree ' | sed 's/^worktree //')
  if [ -z "$worktrees" ]; then
    echo "No worktrees found"
    return 1
  fi
  local selected
  selected=$(printf '%s\n' "$worktrees" | fzf --prompt="worktree> ")
  [ -n "$selected" ] && cd "$selected"
}
