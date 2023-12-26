# Liferay

## General apps

- Antivirus.
- Zoom.
- Slack.

## Environment

```bash
LIFERAY_PORTAL_PATH=/some/path
WOFFU_TOKEN=heyThere
WOFFU_USER_ID=1234
```

## Java

- Install [Apache ANT](https://downloads.apache.org/ant/binaries/) into
  `$HOME/.liferay-apache`
- Install
  [OracleJDK 8](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)
  into `$HOME/.liferay-java`
- Install
  [Apache Maven](https://downloads.apache.org/maven/maven-3/3.9.3/binaries/)
  into `$HOME/.liferay-maven`

## Portal

```bash
mkdir -p ~/Projects/community-portal
cd ~/Projects/community-portal
ln -s $CHACHI_PATH/liferay config
ln -s $CHACHI_PATH/liferay/liferay-editorconfig .editorconfig
git clone git@github.com:p2kmgcl/liferay-portal.git
git clone git@github.com:p2kmgcl/liferay-portal-ee.git
git clone https://github.com/liferay/liferay-binaries-cache-2020.git
rm liferay-portal/.git/config
rm liferay-portal-ee/.git/config
ln -s $CHACHI_PATH/liferay/git-config liferay-portal/.git/config
ln -s $CHACHI_PATH/liferay/git-config-ee liferay-portal-ee/.git/config
```

## First build

```bash
cd ~/Projects/community-portal/liferay-portal
git cifuentes
buildLiferayDXP
cd ~/Projects/community-portal/bundles
ln -s ../config/portal-ext.properties portal-ext.properties
createLiferayDatabase
runLiferayDXP
```

## Setup IntelliJ

```bash
cd ~/Projects/community-portal
git clone https://github.com/holatuwol/liferay-intellij
cd ~/Projects/community-portal/liferay-portal
../liferay-intellij/intellij
```

## GitHub token for SF

Since 2023-04-13, SF looks for vulnerabilities in `build.gradle` files. In order
to make this work, we need to generate a GitHub Legacy/Classic token with the
`read:repo_hook` permission and place it in `$HOME/github.token`.

[Add new GitHub Token](https://github.com/settings/tokens/new).
