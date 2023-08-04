# Seniore

This used to be a separated NodeJS project, written in TypeScript as an
experimental CLI. The old code is still in
_[p2kmgcl/seniore](https://github.com/p2kmgcl/seniore)_, but this is a new
[Rust](/docs/rust) project part of chachi-shell.

> It’s important to add all needed environment variables that are documented in
> [seniore/docs/help.txt](/seniore/docs/help.txt).

## Existing scripts

-   `./install.sh`: add needed dependencies. This might change depending on the
    OS.
-   `./build.sh`: create a production build.
-   `./dev.sh`: starts a development process which builds the project
    automatically.
