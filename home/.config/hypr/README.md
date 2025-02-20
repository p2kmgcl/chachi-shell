# Hyprland

- Base system: `sudo pacman -S hyprland kitty`
- Login manager: `sudo pacman -S sddm && sudo systemctl enable sddm`
- Universal Wayland Session Manager: connects wayland compositor to systemd,
  enabling env variables, XDG autostart, etc: `sudo pacman -S uwsd`
- App launcher: `sudo pacman -S wofi`
- System bar: `sudo pacman -S waybar`
- Audio: `sudo pacman -S pipewire wireplumber`
- Desktop portal: file pickers, screensharing...
  `sudo pacman -S xdg-desktop-portal-gtk xdg-desktop-portal hyprland`
- Notification daemon: `sudo pacman -S mako && systemctl --user enable mako`
- Authentication agent: `sudo pacman -S hyprpolkitagent && systemctl --user enable hyprpolkitagent`


- UI settings: `sudo pacman -S nwg-look qt6-wayland qt6ct`
- Wallpaper: `sudo pacman -S hyprpaper`
