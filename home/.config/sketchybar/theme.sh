# github-colorblind palette — see docs/colorschemes/github-colorblind.md
# macOS leaves AppleInterfaceStyle unset in light mode.
if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = Dark ]; then
  SYSTEM_APPEARANCE=dark
  BAR_FOREGROUND=0xffc9d1d9
  BAR_BACKGROUND=0xcc151b23
  BAR_WORKSPACE_BACKGROUND=0x663d444d
  BAR_OCCUPIED_BACKGROUND=0xcc3d444d
  BAR_ACCENT=0xff58a6ff
  BAR_ACCENT_FOREGROUND=0xff0d1117
  BAR_ATTENTION=0xffd29922
else
  SYSTEM_APPEARANCE=light
  BAR_FOREGROUND=0xff1f2328
  BAR_BACKGROUND=0xccf6f8fa
  BAR_WORKSPACE_BACKGROUND=0x66d1d9e0
  BAR_OCCUPIED_BACKGROUND=0xccd1d9e0
  BAR_ACCENT=0xff0969da
  BAR_ACCENT_FOREGROUND=0xffffffff
  BAR_ATTENTION=0xff9a6700
fi
