export ANT_HOME="/usr/bin/ant"
export ANT_OPTS="-XX:-UseGCOverheadLimit -Xmx8192m -XX:MaxMetaspaceSize=1024m"
export JAVA_HOME="/usr/lib/jvm/default-java"
export NODE_PATH="/usr/lib/node_modules:/home/p2kmgcl/.npm-global/lib/node_modules"

# Database

function createMySQLServer() {
  docker run \
    --name=liferay_portal_database \
    -p=3306:3306 \
    -e MYSQL_DATABASE=liferay_portal \
    -e MYSQL_ROOT_PASSWORD=root \
    -e MYSQL_ROOT_HOST=172.17.0.1 \
    -d mysql/mysql-server:5.7 \
    --character-set-server=utf8 \
    --collation-server=utf8_general_ci
}

function startMySQLServer () {
  docker start $(docker ps -a -q -f name=liferay_portal_database)
}

function connectToMySQLServer () {
  docker exec -it \
    $(docker ps -a -q -f name=liferay_portal_database) \
    mysql -u root -proot
}

function stopMySQLServer () {
  docker stop $(docker ps -a -q -f name=liferay_portal_database)
}

function destroyMySQLServer () {
  docker rm -f $(docker ps -a -q -f name=liferay_portal_database)
}

# Portal

function buildPortal () {
  cd $HOME/Projects/community-portal/liferay-portal && \
    ant all
}

function runPortal () {
  cd $HOME/Projects/community-portal/bundles/tomcat-9.0.17/bin && \
    ./catalina.sh jpda run
}

# Gradlew

function gradlewDeploy () {
  NODE_ENV=development gradlew deploy -a
}

function gradlewCleanDeploy () {
  NODE_ENV=development gradlew clean deploy -Dbuild=portal
}

function gradlewBuildLang () {
  gradlew buildLang
}

function gradlewFormatSource () {
  gradlew formatSource
}

# Pulls

function sendPullTo () {
  BRANCH=`git branch | grep \* | cut -d ' ' -f2`

  git push && \
    git ch master && \
    git br -D $BRANCH && \
    xdg-open "https://github.com/${1}/liferay-portal/compare/master...p2kmgcl:${BRANCH}?quick_pull=1&title=LPS-&body=/cc%20@ealonso"
}

# Export

export -f createMySQLServer
export -f connectToMySQLServer
export -f startMySQLServer
export -f stopMySQLServer
export -f destroyMySQLServer

export -f buildPortal
export -f runPortal

export -f gradlewDeploy
export -f gradlewCleanDeploy
export -f gradlewBuildLang
export -f gradlewFormatSource

export -f sendPullTo
