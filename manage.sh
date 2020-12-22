#!/bin/bash
set -e

SUB_COMMAND=$1
SERVER_PATH="/home/$(whoami)/opt/spigot"

start() {
  screen -ADmS spigot java -Xms2048M -Xmx2048M -jar $SERVER_PATH/spigot-server.jar nogui
}

stop() {
  screen -S spigot -X stuff "say This server will be shutdown in 10s\n"
  sleep 10
  screen -S spigot -X stuff "save-all\n"
  screen -S spigot -X stuff "stop\n"
}

case $SUB_COMMAND in
  'start')
    start
    ;;
  'stop')
    stop
    ;;
esac
