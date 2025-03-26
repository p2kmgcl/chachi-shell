if status is-interactive
    if type -q $HOME/.deno/bin/deno
        export DENO_INSTALL="$HOME/.deno"
        fish_add_path $HOME/.deno/bin
    else
        echo -e "\e[33mdeno is not installed\e[0m"
    end

    if test -d $HOME/.volta
        export VOLTA_HOME="$HOME/.volta"
        fish_add_path $HOME/.volta/bin
        alias man='npx -y tldr'
    else
        echo -e "\e[33mvolta is not installed\e[0m"
    end

    if type -q /opt/homebrew/bin/mkcert
        export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)/rootCA.pem"
    end
end
