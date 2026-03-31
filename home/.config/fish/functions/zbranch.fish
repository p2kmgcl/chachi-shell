function zbranch --description "Switch branch or cd to its worktree"
    set -l branch (git branch --format='%(refname:short)' | fzf --prompt="branch> ")
    or return
    set -l wt (git worktree list --porcelain | grep -B2 "branch refs/heads/$branch\$" | string match 'worktree *' | string replace 'worktree ' '')
    if test -n "$wt"
        cd $wt
    else
        git switch $branch
    end
end
