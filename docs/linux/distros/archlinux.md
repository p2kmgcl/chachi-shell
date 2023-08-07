# ArchLinux

For the first steps, I am going to follow the
[ArchLinux](https://wiki.archlinux.org/title/installation_guide) installation
wiki. I have tried it some years ago, and it gives an usable installation with a
minimum amount of packages installed.

**Wiki FAQ**:

- Only supports x86_64 architecture.
- Uses [systemd](https://wiki.archlinux.org/title/Systemd) as service manager.
- `/bin`, `/sbin` and `/usr/sbin` are symbolic links to `/usr/bin`; `/lib` and
  `/lib64` are symbolic links to `/usr/lib`;
  [more info about filesystem hierarchy](https://man.archlinux.org/man/file-hierarchy.7).
- `pacman -Qlq package_name` gives information about an installed package.
- `systemd-boot` is used to manage a UEFI motherboard.
- `xdg-user-dirs-update.service` takes care of creating user directories like
  "downloads" or "music". This might be enabled by default by the window
  manager.
- ACPI events (power buttons, laptop lid…) can be managed with systemd.
- Firewall is not enabled by default, but iptables can be enabled and should
  work.
- By default it only supports english "standard" keyboard layout.
- `tab-completion` needs to be enabled.
