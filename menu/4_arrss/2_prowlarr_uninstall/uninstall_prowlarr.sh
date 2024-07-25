#!/bin/bash

# Define the container name and volumes
CONTAINER_NAME="prowlarr"
VOLUME_PATH="/opt/appdata/prowlarr/config"

# Stop and remove the prowlarr container
echo "Stopping and removing the prowlarr container..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

# Remove the prowlarr volumes
echo "Removing the prowlarr volumes..."
sudo rm -rf "$VOLUME_PATH"
# Verify removal
echo "Verifying removal..."
docker ps -a | grep $CONTAINER_NAME
docker volume ls | grep $(basename $VOLUME_PATH)

echo "prowlarr has been successfully uninstalled."