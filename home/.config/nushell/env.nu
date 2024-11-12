# Nushell Environment Config File
# version = 0.80.1

let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
}

let-env NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
]

let-env NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

let-env PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.cargo/bin")

let-env PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.local/bin")
let-env PATH = ($env.PATH | split row (char esep) | prepend $"($env.CHACHI_PATH)/home/.bin")

let-env PATH = ($env.PATH | prepend $"($env.HOME)/.fnm")
load-env (fnm env --shell bash | lines | str replace 'export ' '' | str replace -a '"' '' | split column = | rename name value | where name != "FNM_ARCH" and name != "PATH" | reduce -f {} {|it, acc| $acc | upsert $it.name $it.value })
let-env PATH = ($env.PATH | prepend $"($env.FNM_MULTISHELL_PATH)/bin")
let-env PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.deno/bin")
let-env PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.yarn/bin")
let-env DENO_INSTALL = $"($env.HOME)/.deno"

let-env EDITOR = "nvim"

let-env FZF_DEFAULT_COMMAND = 'rg --color=never --files --glob "!.git/*,!.gradle/*,!.hg/*,!.sass-cache/*,!.svn/*,!bower_components/*,!build/*,!classes/*,!CVS/*,!node_modules/*,!tmp/*"'
let-env FZF_DEFAULT_OPTS = '--color=bw'
