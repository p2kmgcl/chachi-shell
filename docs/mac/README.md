# MacOS

## Add environment variables

MacOS uses zsh by default, so you can add this to `$HOME/.zprofile`:

```bash
export CHACHI_PATH="$HOME/path/to/chachi-shell"
```

## Set default shell

[Update default shell in StackOverflow](https://stackoverflow.com/questions/453236/how-can-i-set-my-default-shell-on-a-mac-e-g-to-fish).

1. Add `/path/to/shell` to `/etc/shells`
2. Run `chsh -s /path/to/shell`
3. Reboot
