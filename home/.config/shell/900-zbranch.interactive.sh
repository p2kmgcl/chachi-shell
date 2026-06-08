zbranch() {
  local branch
  branch=$(git branch --format='%(refname:short)' | fzf --prompt="branch> ") || return
  local wt
  wt=$(git worktree list --porcelain | grep -B2 "branch refs/heads/${branch}$" | grep '^worktree ' | sed 's/^worktree //')
  if [ -n "$wt" ]; then
    cd "$wt"
  else
    git switch "$branch"
  fi
}
