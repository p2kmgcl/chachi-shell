set -l pkg_bin_pairs \
    neovim nvim \
    typescript tsc

if status is-interactive
    if test -f "$HOME/.deno/bin/deno"
        export DENO_INSTALL="$HOME/.deno"
        fish_add_path $HOME/.deno/bin
    else
        echo -e "\e[33mdeno is not installed\e[0m"
    end

    if test -d $HOME/.volta
        export VOLTA_HOME="$HOME/.volta"
        fish_add_path $HOME/.volta/bin
        alias man='npx -y tldr'

        for i in (seq 1 2 (count $pkg_bin_pairs))
            set pkg $pkg_bin_pairs[$i]
            set bin $pkg_bin_pairs[(math $i + 1)]

            if not test -f "$(which $bin)"
                echo "Installing missing NPM package $pkg"
                npm install -g $pkg
            end
        end
    else
        echo -e "\e[33mvolta is not installed\e[0m"
    end

    if test -f "$HOME/.yarn/switch/env"
        source "$HOME/.yarn/switch/env"
    else
        echo -e "\e[33myarn is not installed\e[0m"
    end

    if test -f "/opt/homebrew/bin/mkcert"
        export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)/rootCA.pem"
    end
end
