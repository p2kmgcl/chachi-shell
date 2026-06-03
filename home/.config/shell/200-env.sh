export EDITOR='nvim'

[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

if [ -n "$CHACHI_PATH" ] && [ -d "$CHACHI_PATH/home/.bin" ]; then
    export PATH="$CHACHI_PATH/home/.bin:$PATH"
fi

[ -d "/opt/homebrew/bin" ] && export PATH="/opt/homebrew/bin:$PATH"
