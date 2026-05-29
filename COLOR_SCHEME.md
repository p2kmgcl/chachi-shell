# Color Scheme Index

Target: **GitHub Dark Colorblind** everywhere (with Catppuccin Mocha for apps that don't support GitHub themes).

## Changed

| App | File | Setting | Value |
|-----|------|---------|-------|
| Alacritty | `home/.config/alacritty/alacritty.toml` | `[colors.*]` + `decorations_theme_variant` | GitHub Dark Colorblind colors (`#0d1117` bg) |
| Neovim | `home/.config/nvim/lua/autocmds/auto-dark-mode.lua` | `colorscheme` | `github_dark_colorblind` (always, no auto-switch) |
| Helix | `home/.config/helix/config.toml` | `theme` | `github_dark_colorblind` |
| Ghostty | `home/.config/ghostty/config` | `theme` | `GitHub Dark Colorblind` |
| Zed | `home/.config/zed/settings.json` | `theme.mode` | `dark` |
| Kitty | `home/.config/kitty/kitty.conf` | `include` | `dark-theme.auto.conf` (Catppuccin Mocha) |
| WezTerm | `home/.wezterm.lua` | `color_scheme` | `GitHub Dark Default` |

## Needs attention

| App | File | Notes |
|-----|------|-------|
| WezTerm | `home/.wezterm.lua` | Changed to `GitHub Dark Default` — verify the exact scheme name in your WezTerm build (`wezterm ls-fonts --list-system` or browse built-ins). Alternative: define colors inline. |
| Lazygit | `home/.config/lazygit/config.yml` | Uses default terminal colors. Catppuccin Mocha theme files are in `home/.config/lazygit/themes/catppuccin/mocha/`. To activate one, copy its contents into the `gui.theme` block in `config.yml`. |
| Tmux | `home/.config/tmux/tmux.conf` | Uses raw ANSI color codes (colour250, colour7, etc.) — already neutral/dark-friendly, but could be updated to use explicit hex colors aligned with the dark palette. |
| Starship | `home/.config/starship/starship.toml` | Uses named ANSI colors (`blue`, `purple`, `cyan`, etc.) — inherits from the terminal palette, so it automatically benefits from the Alacritty/Kitty/Ghostty dark theme changes. No change needed unless you want specific hex colors. |
| Hyprland | `home/.config/hypr/hyprland.conf` | Border colors are custom (`rgba(33ccffee)` cyan/green gradient) — not tied to a theme, keep as-is or adjust manually. |
| Rofi | `home/.config/rofi/current.rasi` | Solarized dark palette — already dark, but inconsistent with GitHub theme family. Consider updating to match. |

## Theme files

- `home/.config/kitty/dark-theme.auto.conf` — Catppuccin Mocha (active)
- `home/.config/kitty/light-theme.auto.conf` — Catppuccin Latte (unused)
- `home/.config/lazygit/themes/catppuccin/` — 56 Catppuccin variants (4 flavors × 14 accents), currently unused
