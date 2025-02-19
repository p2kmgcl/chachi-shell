# Rust

## Installation

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Analyzer

```bash
rustup component add rust-analyzer
```

### Nice shell utils

- Prompt: `cargo install --locked starship`
- Directory jump: `cargo install --locked zoxide`
- Diffing: `cargo install --locked git-delta`
- Better ls: `cargo install --locked exa`
- Better find: `cargo install --locked fd-find`
- Better cat: `cargo install --locked bat`
- Rust code checker: `cargo install --locked bacon`
- Alternative to top: `cargo install --locked bottom`
- Incredible git tool: `cargo install --locked git-absorb`
- Disk usage: `cargo install --locked du-dust`

All together:

```
cargo install --locked \
  starship \
  zoxide \
  git-delta \
  exa \
  fd-find \
  bat \
  bacon \
  bottom \
  git-absorb \
  du-dust
```
