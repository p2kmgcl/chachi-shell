# JavaScript

## NodeJS

```bash
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "~/.fnm" --skip-shell
fnm install 22 && fnm use 22 && fnm default 22
```

```bash
npm install -g npm

npm install -g \
  bash-language-server \
  dockerfile-language-server-nodejs \
  neovim \
  prettier \
  typescript \
  typescript-language-server \
  vscode-langservers-extracted
```

## Yarn

[Yarn installation process for 2+](https://yarnpkg.com/getting-started/install).

- `corepack enable` (this is provided by latest NodeJS).
- `yarn init -2`
- `yarn set version stable`

## Deno

```bash
curl -fsSL https://deno.land/x/install/install.sh | sh
```

> Deno Language server is included in binary file.
