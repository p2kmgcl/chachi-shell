function zworktree --description "cd into a worktree of the current repo"
    set -l worktrees (git worktree list --porcelain 2>/dev/null | string match 'worktree *' | string replace 'worktree ' '')
    if test (count $worktrees) -eq 0
        echo "No worktrees found"
        return 1
    end
    set -l selected (printf '%s\n' $worktrees | fzf --prompt="worktree> ")
    if test -n "$selected"
        cd $selected
    end
end
