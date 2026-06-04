_fzf_excludes=(--exclude .git --exclude .gradle --exclude .hg --exclude .sass-cache --exclude .svn --exclude bower_components --exclude build --exclude classes --exclude CVS --exclude node_modules --exclude tmp)
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix ${_fzf_excludes[*]}"
export FZF_CTRL_T_COMMAND="fd --type f --strip-cwd-prefix ${_fzf_excludes[*]}"
export FZF_ALT_C_COMMAND="fd --type d --strip-cwd-prefix ${_fzf_excludes[*]}"
export FZF_DEFAULT_OPTS='--color=bw --layout=reverse --prompt="❯ " --no-info --no-separator --height=40%'
export FZF_CTRL_R_OPTS='--with-nth=2..'

command -v fzf >/dev/null && eval "$(fzf --$CURRENT_SHELL)"
