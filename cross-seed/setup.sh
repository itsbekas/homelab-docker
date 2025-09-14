#!/bin/bash

prowlarr_api_key=$(grep '^PROWLARR_API_KEY=' /opt/docker/cross-seed/.env | cut -d'=' -f2-)
sonarr_api_key=$(grep '^SONARR_API_KEY=' /opt/docker/cross-seed/.env | cut -d'=' -f2-)
radarr_api_key=$(grep '^RADARR_API_KEY=' /opt/docker/cross-seed/.env | cut -d'=' -f2-)
qbittorrent_user=$(grep '^QBITTORRENT_USER=' /opt/docker/cross-seed/.env | cut -d'=' -f2-)
qbittorrent_password=$(grep '^QBITTORRENT_PASSWORD=' /opt/docker/cross-seed/.env | cut -d'=' -f2-)

sed -i "s|PROWLARR_API_KEY|$prowlarr_api_key|g" /opt/docker/cross-seed/config/config.js
sed -i "s|SONARR_API_KEY|$sonarr_api_key|g" /opt/docker/cross-seed/config/config.js
sed -i "s|RADARR_API_KEY|$radarr_api_key|g" /opt/docker/cross-seed/config/config.js
sed -i "s|QBITTORRENT_USER|$qbittorrent_user|g" /opt/docker/cross-seed/config/config.js
sed -i "s|QBITTORRENT_PASSWORD|$qbittorrent_password|g" /opt/docker/cross-seed/config/config.js
