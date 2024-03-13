if status is-interactive
    if type -q $HOME/.deno/bin/deno
        export DENO_INSTALL="$HOME/.deno"
        fish_add_path $HOME/.deno/bin
    else
        echo -e "\e[33mdeno is not installed\e[0m"
    end

    if type -q $HOME/.fnm/fnm
        fish_add_path $HOME/.fnm
        fnm env --use-on-cd | source
        alias man='npx -y tldr'
    else if type -q /opt/homebrew/bin/fnm
        fish_add_path $HOME/.fnm
        fnm env --use-on-cd | source
        alias man='npx -y tldr'
    else
        echo -e "\e[33mfnm is not installed\e[0m"
    end
end
