if status is-interactive
    fish_add_path $HOME/.cargo/bin

    if test -f "$HOME/.cargo/bin/exa"
        alias ls='exa'
        alias ll='exa -l'
        alias tree='exa --tree'
    end

    if test -f "$HOME/.cargo/bin/fd"
        alias find='fd --color=never'
    end

    if test -f "$HOME/.cargo/bin/bat"
        alias cat='bat'
    end

    if test -f "$HOME/.cargo/bin/btm"
        alias top='btm --basic --theme default'
        alias htop='btm --basic --theme default'
    end

    if test -f "$HOME/.cargo/bin/zoxide"
        zoxide init fish | source
    end

    if test -f "$HOME/.cargo/bin/starship"
        export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
        starship init fish | source
    end
end
