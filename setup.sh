#!/bin/bash

USAGE=$(cat << DOC
Usage: $0 [COMMAND|OPTION]
  [run]
  [-i|install] <Minecraft Version>
  [-h|--help]
DOC
)

run() {
  java -Xms2048M -Xmx2048M -jar ./spigot-server.jar nogui
}

install() {
  if [ -z $2 ] ; then
    usage
    exit
  fi

  # Install spigot for amazon linux 2
  # Amazon Corretto 8 (openJDK)
  sudo amazon-linux-extras enable corretto8
  sudo yum install java-1.8.0-amazon-corretto-devel

  # Install build props
  sudo yum install git
  git config --global --unset core.autocrlf

  # Build spigot
  wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
  java -jar ./BuildTools.jar --rev $2
  mv ./spigot-$2.jar ./spigot-server.jar
  ln -s ./src/* ./
}

usage() {
  echo "$USAGE"
}

case $1 in
  'run')
    run
    ;;
  '-i'|'install')
    install
    ;;
  '-h'|'--help'|*)
    usage
    ;;
esac
