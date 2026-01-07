if status is-interactive
    export EDITOR='nvim'

    export FZF_DEFAULT_COMMAND='rg --color=never --files --glob "!.git/*,!.gradle/*,!.hg/*,!.sass-cache/*,!.svn/*,!bower_components/*,!build/*,!classes/*,!CVS/*,!node_modules/*,!tmp/*"'
    export FZF_DEFAULT_OPTS='--color=bw'

    fish_add_path $HOME/.local/bin

    if test -z "$CHACHI_PATH"
        if test -d "$HOME/Projects/chachi-shell"
            set -gx CHACHI_PATH "$HOME/Projects/chachi-shell"
        else if test -d "$HOME/chachi-shell"
            set -gx CHACHI_PATH "$HOME/chachi-shell"
        end
    end

    if test -n "$CHACHI_PATH" -a -d "$CHACHI_PATH/home/.bin"
        fish_add_path $CHACHI_PATH/home/.bin
    end

    if test -d /opt/homebrew/bin
        fish_add_path /opt/homebrew/bin
    end
end
