if [ -f "$HOME/.deno/bin/deno" ]; then
    export DENO_INSTALL="$HOME/.deno"
    export PATH="$HOME/.deno/bin:$PATH"
fi

if [ -d "$HOME/.volta" ]; then
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$HOME/.volta/bin:$PATH"
fi

if [ -f "/opt/homebrew/bin/mkcert" ]; then
    export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)/rootCA.pem"
fi
