# Catppuccin Color Scheme

Four flavors: **Latte** (light), **Frappé**, **Macchiato**, **Mocha** (dark, darkest last).  
Source: [`catppuccin/palette`](https://github.com/catppuccin/palette) — canonical upstream palette.

---

## Palette

| Color      | Latte     | Frappé    | Macchiato | Mocha     |
|------------|-----------|-----------|-----------|-----------|
| Rosewater  | `#dc8a78` | `#f2d5cf` | `#f4dbd6` | `#f5e0dc` |
| Flamingo   | `#dd7878` | `#eebebe` | `#f0c6c6` | `#f2cdcd` |
| Pink       | `#ea76cb` | `#f4b8e4` | `#f5bde6` | `#f5c2e7` |
| Mauve      | `#8839ef` | `#ca9ee6` | `#c6a0f6` | `#cba6f7` |
| Red        | `#d20f39` | `#e78284` | `#ed8796` | `#f38ba8` |
| Maroon     | `#e64553` | `#ea999c` | `#ee99a0` | `#eba0ac` |
| Peach      | `#fe640b` | `#ef9f76` | `#f5a97f` | `#fab387` |
| Yellow     | `#df8e1d` | `#e5c890` | `#eed49f` | `#f9e2af` |
| Green      | `#40a02b` | `#a6d189` | `#a6da95` | `#a6e3a1` |
| Teal       | `#179299` | `#81c8be` | `#8bd5ca` | `#94e2d5` |
| Sky        | `#04a5e5` | `#99d1db` | `#91d7e3` | `#89dceb` |
| Sapphire   | `#209fb5` | `#85c1dc` | `#7dc4e4` | `#74c7ec` |
| Blue       | `#1e66f5` | `#8caaee` | `#8aadf4` | `#89b4fa` |
| Lavender   | `#7287fd` | `#babbf1` | `#b7bdf8` | `#b4befe` |
| Text       | `#4c4f69` | `#c6d0f5` | `#cad3f5` | `#cdd6f4` |
| Subtext1   | `#5c5f77` | `#b5bfe2` | `#b8c0e0` | `#bac2de` |
| Subtext0   | `#6c6f85` | `#a5adce` | `#a5adcb` | `#a6adc8` |
| Overlay2   | `#7c7f93` | `#949cbb` | `#939ab7` | `#9399b2` |
| Overlay1   | `#8c8fa1` | `#838ba7` | `#8087a2` | `#7f849c` |
| Overlay0   | `#9ca0b0` | `#737994` | `#6e738d` | `#6c7086` |
| Surface2   | `#acb0be` | `#626880` | `#5b6078` | `#585b70` |
| Surface1   | `#bcc0cc` | `#51576d` | `#494d64` | `#45475a` |
| Surface0   | `#ccd0da` | `#414559` | `#363a4f` | `#313244` |
| Base       | `#eff1f5` | `#303446` | `#24273a` | `#1e1e2e` |
| Mantle     | `#e6e9ef` | `#292c3c` | `#1e2030` | `#181825` |
| Crust      | `#dce0e8` | `#232634` | `#181926` | `#11111b` |

---

## Semantic Roles

### Backgrounds

| Role                          | Color    |
|-------------------------------|----------|
| Main editor / window bg       | Base     |
| Sidebars, panels              | Mantle   |
| Outermost chrome, status bars | Crust    |
| Hover states, selections      | Surface0 |
| Raised elements               | Surface1 |
| Borders, separators           | Surface2 |

### Foregrounds / Text

| Role                | Color    |
|---------------------|----------|
| Primary text        | Text     |
| Secondary labels    | Subtext1 |
| Dimmer secondary    | Subtext0 |
| Disabled / inactive | Overlay2 |
| Comments            | Overlay1 |
| Selection bg        | Overlay0 |

### Syntax

| Element                       | Color     |
|-------------------------------|-----------|
| Keywords, declarations        | Blue      |
| Control flow, statements      | Mauve     |
| Functions, tags               | Pink      |
| Strings                       | Green     |
| Numbers, constants            | Peach     |
| Escape sequences, regex       | Teal      |
| Operators                     | Sky       |
| Links                         | Sapphire  |
| Cursor, identifiers           | Lavender  |
| Special variables             | Flamingo  |
| Punctuation, subtle accents   | Rosewater |
| Errors, deleted diffs         | Red       |
| Warnings (adjacent to red)    | Maroon    |
| Warnings                      | Yellow    |
