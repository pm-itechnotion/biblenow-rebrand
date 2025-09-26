#!/bin/bash
# rexxu

if [[ ! -x "$(command -v docker)" ]]; then
  echo "Error: docker is not installed." >&2
  exit 1
fi
CFG_DIR="/home/"

sudo docker cp docker-jitsi-meet-web-1:/usr/share/jitsi-meet/title.html $CFG_DIR
# Copy config.js from /config
docker cp docker-jitsi-meet-web-1:/config/config.js $CFG_DIR
# Copy interface_config.js (if present) from /config
docker cp docker-jitsi-meet-web-1:/config/interface_config.js $CFG_DIR
