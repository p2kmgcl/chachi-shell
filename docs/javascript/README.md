# JavaScript

## NodeJS

```bash
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "./.fnm" --skip-shell
fnm install 20 && fnm use 20 && fnm alias default 20
```

```bash
npm install -g bash-language-server
npm install -g dockerfile-language-server-nodejs
npm install -g neovim
npm install -g npm
npm install -g prettier
npm install -g typescript-language-server typescript
npm install -g vscode-langservers-extracted
```

## Yarn

[Yarn installation process for 2+](https://yarnpkg.com/getting-started/install).

- `corepack enable` (this is provided by latest NodeJS).
- `yarn init -2`
- `yarn set version stable`
- `yarn install`

## Deno

```bash
curl -fsSL https://deno.land/x/install/install.sh | sh
```

> Deno Language server is included in binary file.
