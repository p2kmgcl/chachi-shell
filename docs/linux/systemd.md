# systemd

Systemd not only manages services, but also sockets, mount points, etc. If no
extension is specified when naming a unit, it will default to `.service`. By
default it operates on system units (`--system` flag doesn't need to be
specified). `--user` can be used to manage user units.

There is a table with some common commands and how unit files work in the
[systemd](https://wiki.archlinux.org/title/Systemd#Basic_systemctl_usage).

In order to run privileged actions (like shutdown or reboot) as an unprivileged
user, and without using sudo to spawn a whole privileged process. Polkit can be
installed and configured. Most desktop environments have authentication agents
that communicate with polkit.

With `/etc/systemd/logind.conf` ACPI events can be configured, and
`/etc/systemd/sleep.conf` to configure how system is suspended.
