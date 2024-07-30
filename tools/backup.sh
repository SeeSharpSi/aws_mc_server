#!/bin/bash
WORLDNAME=$(sed -n 's/^level-name=\(.*\)/\1/p' < /opt/minecraft/server/server.properties)
function rcon {
 /opt/minecraft/tools/mcrcon -H 172.31.88.14 -p oct23 "$1"
 }
rcon "say [§4WARNING§r] World backup process will begin in 5 minutes."
sleep 5s
rcon "say [§4WARNING§r] World backup process is starting NOW."
rcon "save-off"
rcon "save-all"
# cd /opt/minecraft/server
tar -cvpzf /opt/minecraft/backups/worlds/$WORLDNAME-$(date +%F_%R).tar.gz -C /opt/minecraft/server ./$WORLDNAME
rcon "save-on"
rcon "say [§bNOTICE§r] World backup process is complete. Carry on."
# Delete older backups
find /opt/minecraft/backups/worlds -type f -mtime +2 -name "server-*.tar.gz" -delete
find /opt/minecraft/backups/worlds -type f -mtime +2 -name "$WORLDNAME-*.tar.gz" -delete
