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
  echo $NEED_JAVA_16
  if [ $NEED_JAVA_16 = true ]; then
    # Amazon Corretto 16 (openJDK)
    sudo yum install -y https://corretto.aws/downloads/latest/amazon-corretto-16-x64-linux-jdk.rpm
  else
    # Amazon Corretto 8 (openJDK)
    sudo amazon-linux-extras enable corretto8
    sudo yum install -y java-1.8.0-amazon-corretto-devel
  fi

  # Set config
  ln -s $CURRENT_PATH/src/* $INSTALLATION_PATH

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
