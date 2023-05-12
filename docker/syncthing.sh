#!/usr/bin/env bash
docker volume create syncthing_data
docker run --name syncthing \
  --hostname docker.lan \
  --restart unless-stopped \
  -v syncthing_data:/var/syncthing \
  --network host \
  -d syncthing/syncthing:latest

docker run --name syncthing \
  --hostname boomer.lan \
  --restart unless-stopped \
  -v /home/boom:/var/syncthing \
  --network host \
  -e PUID=1000 \
  -e PGID=100 \
  -d syncthing/syncthing:latest
