# JavaScript

## NodeJS

```bash
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "./.fnm" --skip-shell
fnm install 20 && fnm use 20 && fnm alias default 20
```

```bash
npm install -g npm

npm install -g bash-language-server \
  dockerfile-language-server-nodejs \
  neovim \
  prettier \
  typescript-language-server \
  typescript \
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
