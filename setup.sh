#!/bin/bash
set -e

SUB_COMMAND=$1
VERSION=$2
CURRENT_PATH="$(cd $(dirname $0) && pwd)"
INSTALLATION_PATH="/home/$(whoami)/opt/spigot"

USAGE=$(cat << DOC
Usage: $0 [COMMAND|OPTION]
  [-i|install] <Minecraft Version>
  [-h|--help]
DOC
)

install() {
  if [ -z $VERSION ] ; then
    usage
    exit
  fi

  mkdir -p $INSTALLATION_PATH

  # Install spigot for amazon linux 2
  NEED_JAVA_16=`echo $VERSION | awk -F. '{if ( $1 > 1 || $2 >= 17) print "true"; else print "false";}'`
  if [ $NEED_JAVA_16 = true ]; then
    # Amazon Corretto 16 (openJDK)
    sudo rpm --import https://yum.corretto.aws/corretto.key 
    sudo curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
    sudo yum install -y java-16-amazon-corretto-devel
  else
    # Amazon Corretto 8 (openJDK)
    sudo amazon-linux-extras enable corretto8
    sudo yum install -y java-1.8.0-amazon-corretto-devel
  fi

  # Set config
  ln -sf $CURRENT_PATH/src/* $INSTALLATION_PATH

  # Build spigot
  wget -O $CURRENT_PATH/BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
  java -jar $CURRENT_PATH/BuildTools.jar --rev $VERSION
  mv $CURRENT_PATH/spigot-$VERSION.jar $INSTALLATION_PATH/spigot-server.jar

  # Set service
  sudo cp $CURRENT_PATH/systemd/spigot.service /etc/systemd/system/
  sudo systemctl daemon-reload
  sudo systemctl enable spigot
  cp $CURRENT_PATH/manage.sh $INSTALLATION_PATH/manage.sh

  echo 'Success'
}

usage() {
  echo "$USAGE"
}

case $SUB_COMMAND in
  '-i'|'install')
    install
    ;;
  '-h'|'--help'|*)
    usage
    ;;
esac
