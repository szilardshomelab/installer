#!/bin/bash

# Define the container name and volumes
CONTAINER_NAME="qbittorrent"
VOLUME_PATH="/opt/szilardshomelab/appdata/qbittorrent/config"

# Stop and remove the qBittorrent container
echo "Stopping and removing the qBittorrent container..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

# Remove the qBittorrent volumes
echo "Removing the qBittorrent volumes..."
sudo rm -rf "$VOLUME_PATH"
# Verify removal
echo "Verifying removal..."
docker ps -a | grep $CONTAINER_NAME
docker volume ls | grep $(basename $VOLUME_PATH)

echo "qBittorrent has been successfully uninstalled."