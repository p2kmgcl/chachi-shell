# Proton

## Environment setup

- Install `mkcert haproxy bash`
- Ensure installed bash is v4 or later.

## Clients repository

- `git clone https://github.com/ProtonMail/clients.git`
- `yarn start-all --applications "proton-account proton-mail" --api nice.proton.me`

## Desktop repository

- `git clone https://github.com/ProtonMail/desktop.git`
- `yarn start`

## WAT macOS stuff

### Add alias for lazygit config

```bash
ln -s $CHACHI_PATH/home/.config/lazygit ~/Library/Application\ Support/lazygit
```
