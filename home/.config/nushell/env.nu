# Nushell Environment Config File
# version = 0.80.1

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
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

# Directories to search for scripts when calling source or use
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

let-env PATH = ($env.PATH | split row (char esep) | prepend $"/usr/lib/jvm/default-java/bin")
let-env PATH = ($env.PATH | split row (char esep) | prepend $"/usr/lib/jvm/default-ant/bin")
let-env PATH = ($env.PATH | split row (char esep) | prepend $"/usr/lib/jvm/default-maven/bin")
let-env PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/Projects/community-portal/config/bin")
let-env ANT_HOME = "/usr/lib/jvm/default-ant"
let-env ANT_OPTS = "-XX:-UseGCOverheadLimit -Xmx6144m -XX:MaxMetaspaceSize=1024m"
let-env GRADLE_OPTS = "-Dorg.gradle.daemon=false"
let-env JAVA_HOME = "/usr/lib/jvm/default-java"

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
