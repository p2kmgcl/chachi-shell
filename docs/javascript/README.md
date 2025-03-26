# JavaScript

## NodeJS

```bas
curl https://get.volta.sh | bash -s -- --skip-setup
```

```bash
volta install node
```

```bash
npm install -g npm
```

```bash
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
