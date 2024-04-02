# Proton

## Environment setup

- Install `mkcert haproxy bash`
- Ensure installed bash is v4 or later.

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

Then work from this repository, and create some aliases inside the VM to reuse
the source code. Note that forge.config.ts cannot be aliased, as it produces
some errors when running the application.

```bash
export VM_APP="$HOME/proton-desktop" && \
  export SHARED_APP="/media/share/proton-desktop" && \
  echo aliasing to $VM_APP && \
  echo from $SHARED_APP && \
  mkdir -p $VM_APP && \
  cd $VM_APP && \
  ln -s $SHARED_APP/assets && \
  ln -s $SHARED_APP/src && \
  ln -s $SHARED_APP/tasks && \
  ln -s $SHARED_APP/package.json && \
  ln -s $SHARED_APP/tsconfig.json && \
  ln -s $SHARED_APP/webpack.main.config.ts && \
  ln -s $SHARED_APP/webpack.plugins.ts && \
  ln -s $SHARED_APP/webpack.renderer.config.ts && \
  ln -s $SHARED_APP/webpack.rules.ts && \
  cp $SHARED_APP/forge.config.ts . && \
  echo done, running yarn && \
  yarn
```

## WAT macOS stuff

- Add alias for lazygit config:
  `ln -s $CHACHI_PATH/home/.config/lazygit ~/Library/Application\ Support/lazygit`
