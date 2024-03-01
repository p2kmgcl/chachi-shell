if status is-interactive
    export ANT_HOME="$HOME/.liferay-ant"
    export JAVA_HOME="$HOME/.liferay-java"
    export JPM_HOME="$HOME/.liferay-jpm"
    export MAVEN_HOME="$HOME/.liferay-maven"

    export ANT_OPTS="-XX:-UseGCOverheadLimit -Xmx6144m -XX:MaxMetaspaceSize=1024m"
    export GRADLE_OPTS="-Dorg.gradle.daemon=false"

    fish_add_path $ANT_HOME/bin
    fish_add_path $JAVA_HOME/bin
    fish_add_path $JPM_HOME/bin
    fish_add_path $MAVEN_HOME/bin
    fish_add_path $CHACHI_PATH/liferay/bin
end
