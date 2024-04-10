# Proton

## Environment setup

- Install
  [mkcert](https://github.com/FiloSottile/mkcert?tab=readme-ov-file#installation)
- Install `haproxy`
- Install `bash` 4.0 or later

## Clients repository

```bash
git clone https://github.com/ProtonMail/clients.git ~/Projects/proton-clients
```

This nice command can run all needed web clients using domain aliases
(`proton.local`) and using a valid SSL certificate:

```bash
yarn start-all --applications "proton-account proton-mail" --api nice.proton.me
```

In order to access `proton.local` from other VMs, we need to redirect the
request to a valid IP. We **do** need to reuse the `https://*.proton.local`
domain instead of the RAW IP, because with the current webpack configuration the
application is being served as HTTP instead of HTTPS, and some features (like
crypto) won't be available. Update the VM `/etc/hosts` file with this content
(extracted from `proton-clients/utilities/local-sso/etc_hosts.txt`):

> Windows hosts file is located in `C:\Windows\System32\drivers\etc\hosts`

```plain
# Proton local-dev start
My.Local.Ip account.proton.local
My.Local.Ip account-api.proton.local
My.Local.Ip calendar.proton.local
My.Local.Ip calendar-api.proton.local
My.Local.Ip mail.proton.local
My.Local.Ip mail-api.proton.local
My.Local.Ip drive.proton.local
My.Local.Ip drive-api.proton.local
My.Local.Ip vpn.proton.local
My.Local.Ip vpn-api.proton.local
My.Local.Ip pass.proton.local
My.Local.Ip pass-api.proton.local
# Proton local-dev end
```

## Desktop repository

Checkout this repository in a directory that can be shared with other virtual
machines, so the application can be run easily without copying all the files:

```bash
git clone https://github.com/ProtonMail/desktop.git ~/Projects/vmshared/proton-desktop
```

### Windows development

Install NodeJS, rsync and cygwin, then copy everything before running the
application. This will avoid issues with symbolic links that do not work the
same on windows:

```bash
rsync \
  --progress \
  --recursive \
  --inplace \
  --exclude=node_modules \
  --exclude=.git \
  --exclude=.webpack \
  --exclude=.husky \
  --exclude=out \
  /cygdrive/z/proton-desktop/ /cygdrive/c/Users/windows/proton-desktop \
  && cd /cygdrive/c/Users/windows/proton-desktop && yarn && yarn start
```

### Linux development

Install NodeJS and rsync and copy everything before running the application
(same issue than windows with symbolic links):

```bash
rsync \
  --progress \
  --recursive \
  --inplace \
  --exclude=node_modules \
  --exclude=.git \
  --exclude=.webpack \
  --exclude=.husky \
  --exclude=out \
  /media/share/proton-desktop/ $HOME/proton-desktop \
  && cd $HOME/proton-desktop && yarn && yarn start
```

## WAT macOS stuff

- Add alias for lazygit config:
  `ln -s $CHACHI_PATH/home/.config/lazygit ~/Library/Application\ Support/lazygit`
