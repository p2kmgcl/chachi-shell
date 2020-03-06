export PATH=$HOME/.npm-global/bin:$PATH
export NODE_PATH=/usr/lib/node_modules:$HOME/.npm-global/lib/node_modules:$NODE_PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/p2kmgcl/.oh-my-zsh"

# Set "random" (echo $RANDOM_THEME)
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="cloud"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(auto-notify git zsh-256color zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
