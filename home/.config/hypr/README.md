# Hyprland

- Base system: `sudo pacman -S hyprland kitty`
- Login manager: `sudo pacman -S sddm && sudo systemctl enable sddm`
- Universal Wayland Session Manager: connects wayland compositor to systemd,
  enabling env variables, XDG autostart, etc: `sudo pacman -S uwsd`
- App launcher: `sudo pacman -S rofi rofi-emoji`
- System bar: `sudo pacman -S waybar`
- Audio: `sudo pacman -S pipewire wireplumber`
- Desktop portal: file pickers, screensharing...
  `sudo pacman -S xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland`
- Notification daemon: `sudo pacman -S libnotify mako && systemctl --user enable mako`
- Authentication agent: `sudo pacman -S hyprpolkitagent && systemctl --user enable hyprpolkitagent`
- Audio control: `sudo pacman -S pavucontrol pactl playerctl`
- Brightness control: `sudo pacman -S brightnessctl`
- Power control: `sudo pacman -S powerprofilesctl`
- Network manager: `sudo pacman -S network-manager-applet`
- Clipboard: `sudo pacman -S wl-clipboard`
- Screenshots: `sudo pacman -S grim slurp swappy`
- Screen record: `sudo pacman -S wf-recorder gifski slurp`
- Bluetooth: `sudo pacman -S bluez bluez-utils blueman && sudo systemctl enable --now bluetooth.service`

- File manager: `sudo pacman -S nautilus`
- UI settings: `sudo pacman -S nwg-look qt6-wayland qt6ct`
- Image viewer: `sudo pacman -S eog`
- File compress: `sudo pacman -S xarchiver zip unzip`
- Image editor: `sudo pacman -S gimp gimp-plugin-gmic inkscape`
- Torrent: `sudo pacman -S transmission-gtk`
- Video player: `sudo pacman -S clapper`
- Wallpaper: `sudo pacman -S hyprpaper`
