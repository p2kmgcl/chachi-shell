if status is-interactive
    fish_add_path $HOME/.cargo/bin

    if type -q exa
        alias ls='exa'
        alias ll='exa -l'
        alias tree='exa --tree'
    end

    if type -q fd
        alias find='fd --color=never'
    end

    if type -q bat
        alias cat='bat'
    end

    if type -q btm
        alias top='btm --basic --theme default'
        alias htop='btm --basic --theme default'
    end

    if type -q zoxide
        zoxide init fish | source
    end

    if type -q starship
        export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
        starship init fish | source
    end
end
