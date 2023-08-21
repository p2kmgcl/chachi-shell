# Linux system maintenance

- Update repositories mirrorlist (this depends on the package manager).
- Check and clear log errors:
  - `systemctl --failed`
  - `journalctl --priority 4 --reverse`
  - `journalctl --vacuum-time=2days`
