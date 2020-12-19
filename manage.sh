#!/bin/bash
set -e

SUB_COMMAND=$1
SERVER_PATH="/home/$(whoami)/opt/spigot"

start() {
  screen -Dm -S spigot -X /usr/bin/java -Xms2048M -Xmx2048M -jar $SERVER_PATH/spigot-server.jar
}

stop() {
  screen -S spigot -X stuff "This server will be shutdown in 10s\015"
  sleep 10
  screen -S spigot -X stuff "save-all\015"
  screen -S spigot -X stuff "stop\015"
}

case $SUB_COMMAND in
  'start')
    start
    ;;
  'stop')
    stop
    ;;
esac
