#!/bin/bash

# Define the container name and volumes
CONTAINER_NAME="radarr"
VOLUME_PATH="/opt/szilardshomelab/appdata/radarr/config"

# Stop and remove the radarr container
echo "Stopping and removing the radarr container..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

# Remove the radarr volumes
echo "Removing the radarr volumes..."
sudo rm -rf "$VOLUME_PATH"
# Verify removal
echo "Verifying removal..."
docker ps -a | grep $CONTAINER_NAME
docker volume ls | grep $(basename $VOLUME_PATH)

echo "Radarr has been successfully uninstalled."