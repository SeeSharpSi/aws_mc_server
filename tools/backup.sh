#!/bin/bash
WORLDNAME=$(sed -n 's/^level-name=\(.*\)/\1/p' < /opt/minecraft/server/server.properties)
function rcon {
 /opt/minecraft/tools/mcrcon -H replacemewithip -p oct23 "$1"
 }
rcon "say [§4WARNING§r] World backup process will begin in 5 minutes."
sleep 5m
rcon "say [§4WARNING§r] World backup process is starting NOW."
rcon "save-off"
rcon "save-all"
tar -cvpzf /opt/minecraft/backups/worlds/$WORLDNAME-$(date +%F_%R).tar.gz /opt/minecraft/server/$WORLDNAME
rcon "save-on"
rcon "say [§bNOTICE§r] World backup process is complete. Carry on."
# Delete older backups
find /opt/minecraft/backups/worlds -type f -mtime +4 -name "server-*.tar.gz" -delete
