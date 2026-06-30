# GitHub Colorblind Color Scheme

Formally named **light/dark-protanopia-deuteranopia** (red-green colorblindness safe).  
Source: [`@primer/primitives`](https://github.com/primer/primitives) — GitHub's design token system.

The key adaptation: **green → blue** for success/additions, **red → orange** for danger/deletions.

---

## Backgrounds

| Token                        | Light          | Dark              |
|------------------------------|----------------|-------------------|
| default                      | `#ffffff`      | `#0d1117`         |
| muted                        | `#f6f8fa`      | `#151b23`         |
| inset                        | —              | `#010409`         |
| disabled                     | `#eff2f5`      | `#212830`         |
| emphasis                     | `#25292e`      | `#3d444d`         |
| inverse                      | `#25292e`      | `#ffffff`         |
| accent emphasis              | `#0969da`      | `#1f6feb`         |
| accent muted                 | `#ddf4ff`      | `#388bfd1a`       |
| success emphasis *(blue)*    | `#0969da`      | `#1f6feb`         |
| success muted *(blue)*       | `#ddf4ff`      | `#388bfd33`       |
| danger emphasis *(orange)*   | `#bc4c00`      | `#bd561d`         |
| danger muted *(orange)*      | `#fff1e5`      | `#db6d281a`       |
| attention emphasis           | `#9a6700`      | `#9e6a03`         |
| attention muted              | `#fff8c5`      | `#bb800926`       |
| done emphasis                | `#8250df`      | `#8957e5`         |
| done muted                   | `#fbefff`      | `#ab7df826`       |
| open emphasis *(orange)*     | `#bc4c00`      | `#bd561d`         |
| open muted *(orange)*        | `#fff1e5`      | `#db6d281a`       |
| severe emphasis *(orange)*   | `#bc4c00`      | `#bd561d`         |
| severe muted *(orange)*      | `#fff1e5`      | `#db6d281a`       |
| neutral emphasis             | `#59636e`      | `#656c76`         |
| neutral muted                | `#818b981f`    | `#656c7633`       |
| sponsors emphasis            | `#bf3989`      | `#bf4b8a`         |
| sponsors muted               | `#ffeff7`      | `#db61a21a`       |

## Foregrounds

| Token                        | Light          | Dark       |
|------------------------------|----------------|------------|
| default                      | `#1f2328`      | `#f0f6fc`  |
| muted                        | `#59636e`      | `#9198a1`  |
| disabled                     | `#818b98`      | `#656c76`  |
| on-emphasis                  | `#ffffff`      | —          |
| link / accent                | `#0969da`      | `#4493f8`  |
| success *(blue)*             | `#0969da`      | `#58a6ff`  |
| danger *(orange)*            | `#bc4c00`      | `#f0883e`  |
| attention                    | `#9a6700`      | `#d29922`  |
| done                         | `#8250df`      | `#ab7df8`  |
| open *(orange)*              | `#bc4c00`      | `#db6d28`  |
| severe *(orange)*            | `#bc4c00`      | `#db6d28`  |
| sponsors                     | `#bf3989`      | `#db61a2`  |
| neutral                      | `#59636e`      | `#9198a1`  |

## Borders

| Token                        | Light          | Dark           |
|------------------------------|----------------|----------------|
| default                      | `#d1d9e0`      | `#3d444d`      |
| muted                        | `#d1d9e0b3`    | `#3d444db3`    |
| emphasis                     | `#818b98`      | `#656c76`      |
| translucent                  | `#1f232826`    | `#ffffff26`    |
| accent emphasis              | `#0969da`      | `#1f6feb`      |
| accent muted                 | `#54aeff66`    | `#388bfd66`    |
| success emphasis *(blue)*    | `#0969da`      | `#1f6feb`      |
| success muted *(blue)*       | `#ddf4ff`      | `#388bfd66`    |
| danger emphasis *(orange)*   | `#bc4c00`      | `#bd561d`      |
| danger muted *(orange)*      | `#fff1e5`      | `#db6d2866`    |
| attention emphasis           | `#9a6700`      | `#9e6a03`      |
| attention muted              | `#d4a72c66`    | `#bb800966`    |
| done emphasis                | `#8250df`      | `#8957e5`      |
| done muted                   | `#c297ff66`    | `#ab7df866`    |
| open emphasis *(orange)*     | `#bc4c00`      | `#bd561d`      |
| open muted *(orange)*        | `#fb8f4466`    | `#db6d2866`    |
| sponsors emphasis            | `#bf3989`      | —              |
| sponsors muted               | `#ff80c866`    | —              |

## Diff

| Role                         | Light          | Dark           |
|------------------------------|----------------|----------------|
| addition line bg *(blue)*    | `#ddf4ff`      | `#388bfd26`    |
| addition word highlight      | `#b6e3ff`      | `#388bfd66`    |
| addition line number         | `#b6e3ff`      | `#58a6ff4d`    |
| deletion line bg *(orange)*  | `#fff1e5`      | `#db6d2826`    |
| deletion word highlight      | `#ffd8b5`      | `#db6d2866`    |
| deletion line number         | `#ffd8b5`      | `#db6d284d`    |
| hunk line bg                 | `#f6f8fa`      | `#212830`      |

## Syntax (Prettylights)

| Role                         | Light fg       | Light bg       | Dark fg        | Dark bg        |
|------------------------------|----------------|----------------|----------------|----------------|
| constant                     | `#0550ae`      | —              | `#79c0ff`      | —              |
| keyword                      | `#bc4c00`      | —              | `#f0883e`      | —              |
| string                       | `#0a3069`      | —              | `#a5d6ff`      | —              |
| variable                     | `#953800`      | —              | `#ffa657`      | —              |
| entity                       | `#6639ba`      | —              | `#d2a8ff`      | —              |
| comment                      | `#59636e`      | —              | `#9198a1`      | —              |
| inserted *(blue)*            | `#0550ae`      | `#ddf4ff`      | `#cae8ff`      | `#0c2d6b`      |
| deleted *(orange)*           | `#762c00`      | `#fff1e5`      | `#ffdfb6`      | `#5a1e02`      |
| changed *(orange)*           | `#953800`      | `#ffd8b5`      | `#ffdfb6`      | `#5a1e02`      |
| meta diff range              | `#8250df`      | —              | `#d2a8ff`      | —              |

## ANSI Terminal

| Color          | Light          | Light Bright   | Dark           | Dark Bright    |
|----------------|----------------|----------------|----------------|----------------|
| black          | `#1f2328`      | `#393f46`      | `#2f3742`      | `#656c76`      |
| white          | `#59636e`      | `#818b98`      | `#f0f6fc`      | `#ffffff`      |
| gray           | `#59636e`      | —              | `#656c76`      | —              |
| red *(orange)* | `#bc4c00`      | `#953800`      | `#f0883e`      | `#ffa657`      |
| green *(blue)* | `#0550ae`      | `#0969da`      | `#58a6ff`      | `#79c0ff`      |
| yellow         | `#4d2d00`      | `#633c01`      | `#d29922`      | `#e3b341`      |
| blue           | `#0969da`      | `#218bff`      | `#58a6ff`      | `#79c0ff`      |
| magenta        | `#8250df`      | `#a475f9`      | `#be8fff`      | `#d2a8ff`      |
| cyan           | `#1b7c83`      | `#3192aa`      | `#39c5cf`      | `#56d4dd`      |

---

## Delta gitconfig (light)

```ini
[delta]
  light = true
  syntax-theme = GitHub
  minus-style = syntax "#fff1e5"
  minus-emph-style = normal "#ffd8b5"
  plus-style = syntax "#ddf4ff"
  plus-emph-style = normal "#b6e3ff"
```
