#!/bin/bash

# Define the container name and volumes
CONTAINER_NAME="sonarr"
VOLUME_PATH="/opt/szilardshomelab/appdata/sonarr/config"

# Stop and remove the sonarr container
echo "Stopping and removing the sonarr container..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

# Remove the sonarr volumes
echo "Removing the sonarr volumes..."
sudo rm -rf "$VOLUME_PATH"
# Verify removal
echo "Verifying removal..."
docker ps -a | grep $CONTAINER_NAME
docker volume ls | grep $(basename $VOLUME_PATH)

echo "sonarr has been successfully uninstalled."