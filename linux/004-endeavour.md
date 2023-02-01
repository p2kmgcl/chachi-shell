# EndeavourOS

1. Install `IBM Plex` font.
2. `mkdir -p ~/.config/alacritty && ln -s ~/Projects/chachi-shell/config/alacritty.yml ~/.config/alacritty/alacritty.yml`.
3. Add to /etc/environment:

   ```
   # Used to get weather
   HOMETOWN="some-place"

   # Login system
   WOFFU_SIGNS_FILE="/tmp/woffu-signs"
   WOFFU_PRESENCE_FILE="/tmp/woffu-presence"
   WOFFU_TOKEN="some-token"
   WOFFU_USER_ID="some-user-id"
   ```

4. Install `xdg-desktop-portal-gnome xdg-desktop-portal-gtk xdg-desktop-portal`
   to allow screen sharing in GNOME+Wayland (not included by default).
