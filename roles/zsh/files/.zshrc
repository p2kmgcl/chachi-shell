# Path to your oh-my-zsh installation.
export ZSH="/home/p2kmgcl/.oh-my-zsh"

###############################################################################
# Liferay #####################################################################
###############################################################################

# Env
export ANT_HOME="/usr/bin/ant"
export ANT_OPTS="-XX:-UseGCOverheadLimit -Xmx8192m -XX:MaxMetaspaceSize=1024m"
export JAVA_HOME="/usr/lib/jvm/default-java"

# Database
alias destroyLiferayDatabase="docker rm -f $(docker ps -a -q -f name=liferay_portal_database)"
alias createLiferayDatabase="docker run --name=liferay_portal_database -p=3306:3306 -e MYSQL_DATABASE=liferay_portal -e MYSQL_ROOT_PASSWORD=root -e MYSQL_ROOT_HOST=172.17.0.1 -d mysql/mysql-server:5.7 --character-set-server=utf8 --collation-server=utf8_general_ci"
alias connectToLiferayDatabase="docker exec -it $(docker ps -a -q -f name=liferay_portal_database) mysql -u root -proot"

# Portal
alias buildLiferayPortal="cd $HOME/Projects/community-portal/liferay-portal && ant setup-profile-portal && ant all -Dnodejs.node.env=development"
alias runLiferayPortal="cd $HOME/Projects/community-portal/bundles/tomcat-9.0.33/bin && ./catalina.sh jpda run"

# Gradlew
alias gradlewDeploy="NODE_ENV=development gradlew deploy -a"
alias gradlewCleanDeploy="NODE_ENV=development gradlew clean deploy -Dbuild=portal"
alias gradlewFastDeploy="NODE_ENV=development gradlew deploy && NODE_ENV=development gradlew deployFast -at"
alias gradlewBuildLang="gradlew buildLang"
alias gradlewFormatSource="gradlew formatSource"

###############################################################################
# NodeJS ######################################################################
###############################################################################

export PATH=$HOME/.npm-global/bin:$PATH
export NODE_PATH=/usr/lib/node_modules:$HOME/.npm-global/lib/node_modules:$NODE_PATH

###############################################################################
# FZF #########################################################################
###############################################################################

export FZF_DEFAULT_COMMAND='rg --color=never --files --glob "!.git/*,!.gradle/*,!.hg/*,!.sass-cache/*,!.svn/*,!bower_components/*,!build/*,!classes/*,!CVS/*,!node_modules/*,!tmp/*"'
export FZF_DEFAULT_OPTS='--color=bw'

###############################################################################
# Misc ########################################################################
###############################################################################

alias o=xdg-open

###############################################################################
# ZSH #########################################################################
###############################################################################

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
plugins=(autojump git zsh-256color zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
