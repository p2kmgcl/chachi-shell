# Web UI

Apply these additional rules only when `write-code` is operating in the Web UI
repository.

**Scaffolding.** Discover generators through
`$HOME/.yarn/switch/bin/yarn cli --help` and its AI documentation. Add
dependencies with `$HOME/.yarn/switch/bin/yarn add`.

**Validation.** Run `$HOME/.yarn/switch/bin/yarn greyhound typecheck` for all
relevant files, `$HOME/.yarn/switch/bin/yarn eslint <paths>` for focused linting,
and `$HOME/.yarn/switch/bin/yarn test <paths>` for focused tests.

**Dependencies.** Respect this import matrix:

| Can import         | @lib/\* | @api/\* | @api/http-\* | @_-lib/_ | @_-components/_ | @_-toolkit/_ | @~_-runtime/_            | @router/\* | @\*-unsafe-runtime |
| ------------------ | ------- | ------- | ------------ | -------- | --------------- | ------------ | ------------------------ | ---------- | ------------------ |
| @lib/\*            | yes     | no      | no           | no       | no              | no           | no                       | no         | no                 |
| @api/\*            | yes     | yes     | yes          | no       | no              | no           | no                       | no         | no                 |
| @api/http-\*       | yes     | no      | yes          | no       | no              | no           | no                       | no         | no                 |
| @_-lib/_           | yes     | no      | no           | yes      | no              | no           | no                       | no         | no                 |
| @_-components/_    | yes     | no      | no           | yes      | yes             | no           | no                       | no         | no                 |
| @_-toolkit/_       | yes     | yes     | yes          | yes      | yes             | yes          | no                       | no         | no                 |
| @~_-runtime/_      | yes     | yes     | yes          | yes      | yes             | yes          | yes (from the same team) | yes        | yes                |
| @router/\*         | yes     | yes     | yes          | yes      | no              | no           | no                       | yes        | no                 |
| @\*-unsafe-runtime | yes     | yes     | yes          | yes      | yes             | yes          | yes (from the same team) | yes        | yes                |

Type-only imports may cross these boundaries when the referenced package is a
development dependency.
