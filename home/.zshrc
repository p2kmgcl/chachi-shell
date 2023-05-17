export LANG=en_US.utf8

# Run sway on tty1

if [ "$(tty)" = "/dev/tty1" ] ; then
    export QT_QPA_PLATFORM=wayland
    export MOZ_ENABLE_WAYLAND=1
    export MOZ_WEBRENDER=1
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway
    export _JAVA_AWT_WM_NONREPARENTING=1

    echo Booting sway...
    exec sway && exit
    echo Exiting...
fi

# Load tmux if possible
if [ ! "JetBrains-JediTerm" = "${TERMINAL_EMULATOR}" ] && [ -n "$(which tmux)" ] && [ -z "${TMUX}" ]; then
  tmux new-session -A -s CHACHI_SHELL && exit 0
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

###############################################################################
# ENV #########################################################################
###############################################################################

export GRADLE_OPTS="-Dorg.gradle.daemon=false"
export ANT_HOME="/usr/lib/jvm/default-ant"
export ANT_OPTS="-XX:-UseGCOverheadLimit -Xmx6144m -XX:MaxMetaspaceSize=1024m"
export EDITOR="nvim"
export JAVA_HOME="/usr/lib/jvm/default-java"
export DENO_INSTALL="$HOME/.deno"
export PATH=$HOME/.local/bin:$CHACHI_PATH/home/.bin:$HOME/Projects/community-portal/config/bin:$HOME/.yarn/bin:/usr/lib/jvm/default-java/bin:/usr/lib/jvm/default-ant/bin:/usr/lib/jvm/default-maven/bin:$HOME/.cargo/bin:$PATH:$DENO_INSTALL/bin

###############################################################################
# NodeJS ######################################################################
###############################################################################

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

###############################################################################
# FZF #########################################################################
###############################################################################

export FZF_DEFAULT_COMMAND='rg --color=never --files --glob "!.git/*,!.gradle/*,!.hg/*,!.sass-cache/*,!.svn/*,!bower_components/*,!build/*,!classes/*,!CVS/*,!node_modules/*,!tmp/*"'
export FZF_DEFAULT_OPTS='--color=bw'

###############################################################################
# Misc ########################################################################
###############################################################################

alias o=xdg-open
alias readme="nvim ~/Projects/chachi-shell/README.md"
alias gfs="seniore gradlew formatSource"
alias gcd="seniore deploy"
alias gda="seniore deploy --all"

###############################################################################
# ZSH #########################################################################
###############################################################################

# Set "random" (echo $RANDOM_THEME)
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="mgutz"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(autojump zsh-autosuggestions)

[ -f $ZSH/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh