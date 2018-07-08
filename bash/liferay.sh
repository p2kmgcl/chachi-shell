export ANT_HOME="/usr/bin/ant"
export ANT_OPTS="-XX:-UseGCOverheadLimit -Xmx8192m -XX:MaxMetaspaceSize=1024m"
export NODE_PATH="/usr/lib/node_modules:~/.npm-global/lib/node_modules"

# Database

function createMySQLServer() {
  docker run \
    --name=liferay_portal_database \
    -p=3306:3306 \
    -e MYSQL_DATABASE=liferay_portal \
    -e MYSQL_ROOT_PASSWORD=root \
    -e MYSQL_ROOT_HOST=172.17.0.1 \
    -d mysql/mysql-server:5.7 \
    --character-set-server=utf8mb4 \
    --collation-server=utf8mb4_unicode_ci
}

function startMySQLServer () {
  docker start $(docker ps -a -q -f name=liferay_portal_database)
}

function stopMySQLServer () {
  docker stop $(docker ps -a -q -f name=liferay_portal_database)
}

function destroyMySQLServer () {
  docker rm -f $(docker ps -a -q -f name=liferay_portal_database)
}

# Portal

function buildPortal () {
  cd ~/Projects/community-portal/liferay-portal && \
    ant all
}

function runPortal () {
  cd ~/Projects/community-portal/bundles/tomcat-9.0.6/bin && \
    ./catalina.sh jpda run
}

# Gradlew

function gradlewDeploy () {
  gradlew deploy -a
}

function gradlewFullDeploy () {
  gradlew clean deploy -Dbuild=portal
}

function gradlewBuildLang () {
  gradlew buildLang
}

function gradlewFormatSource () {
  gradlew formatSource && npm run csf -- -q
}

function gradlewNpmInstall () {
  gradlew npmInstall
}

# Export

export -f createMySQLServer
export -f startMySQLServer
export -f stopMySQLServer
export -f destroyMySQLServer

export -f buildPortal
export -f runPortal

export -f gradlewDeploy
export -f gradlewFullDeploy
export -f gradlewBuildLang
export -f gradlewFormatSource
export -f gradlewNpmInstall