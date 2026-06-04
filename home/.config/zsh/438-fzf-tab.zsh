_fzf_tab="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
[ -f "$_fzf_tab" ] && source "$_fzf_tab"
unset _fzf_tab
