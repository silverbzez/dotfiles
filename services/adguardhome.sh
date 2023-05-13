#!/usr/bin/env bash
docker volume create adguardhome_work
docker volume create adguardhome_conf
docker run --name adguardhome \
  --restart unless-stopped \
  -v adguardhome_work:/opt/adguardhome/work \
  -v adguardhome_conf:/opt/adguardhome/conf \
  -p 53:53/tcp -p 53:53/udp \
  -p 10001:3000/tcp \
  -d adguard/adguardhome:latest
