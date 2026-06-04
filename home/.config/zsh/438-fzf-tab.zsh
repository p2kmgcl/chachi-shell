_fzf_tab="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"

if [ -f "$_fzf_tab" ]; then
  source "$_fzf_tab"
fi

unset _fzf_tab
