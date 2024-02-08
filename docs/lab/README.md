# Lab

## Install Cockpit

[Cockpit Project](https://cockpit-project.org/).

> Remove `/etc/network/interfaces` so it can be managed by Cockpit
> (NetworkManager).

## Install docker

[Docker install from repo](https://docs.docker.com/engine/install/debian/#install-using-the-repository).

## Install portainer

[Portainer CE for docker standalone](https://docs.portainer.io/start/install-ce/server/docker/linux).

## Home assistant supervised

- [Home Assistant supervised repo](https://github.com/home-assistant/supervised-installer).
- Ignore other containers:
  - `ha jobs options --ignore-conditions healthy`
  - `ha supervisor restart`
- [Install HACS](https://hacs.xyz/docs/setup/download).

## Avoid shutdown on lid close

`/etc/systemd/logind.conf`:

```txt
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
```
