_fzf_tab_dir="$HOME/.fzf-tab"

if [ ! -d "$_fzf_tab_dir" ]; then
  echo "📦 Cloning fzf-tab into $_fzf_tab_dir…"
  git clone -q --depth 1 https://github.com/Aloxaf/fzf-tab "$_fzf_tab_dir"
fi

if [ -f "$_fzf_tab_dir/fzf-tab.plugin.zsh" ]; then
  source "$_fzf_tab_dir/fzf-tab.plugin.zsh"
fi

unset _fzf_tab_dir
