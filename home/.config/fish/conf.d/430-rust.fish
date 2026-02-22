if status is-interactive
    fish_add_path $HOME/.cargo/bin

    if test -f "$HOME/.cargo/bin/exa"
        alias exa_list='exa -l'
        alias exa_tree='exa --tree'
    end

    if test -f "$HOME/.cargo/bin/fd"
        alias fd_nocolor='fd --color=never'
    end

    if test -f "$HOME/.cargo/bin/btm"
        alias btm_basic='btm --basic --theme default'
    end

    if test -f "$HOME/.cargo/bin/zoxide"
        zoxide init fish | source
    end

    if test -f "$HOME/.cargo/bin/starship"
        export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
        starship init fish | source
    end
end
