if status is-interactive
  set -U ANT_HOME "$HOME/.liferay-ant"
  set -U JAVA_HOME "$HOME/.liferay-java"
  set -U JPM_HOME "$HOME/.liferay-jpm"
  set -U MAVEN_HOME "$HOME/.liferay-maven"

  set -U ANT_OPTS "-XX:-UseGCOverheadLimit -Xmx6144m -XX:MaxMetaspaceSize=1024m"
  set -U GRADLE_OPTS "-Dorg.gradle.daemon=false"

  fish_add_path $ANT_HOME/bin
  fish_add_path $JAVA_HOME/bin
  fish_add_path $JPM_HOME/bin
  fish_add_path $MAVEN_HOME/bin
  fish_add_path $HOME/Projects/community-portal/config/bin
end
