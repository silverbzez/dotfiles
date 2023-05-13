#!/usr/bin/env bash
docker volume create portainer_data
docker run --name portainer \
  --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  -p 10000:9000/tcp \
  -d portainer/portainer-ce:latest
