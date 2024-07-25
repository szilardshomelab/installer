#!/bin/bash

# Define the container name and volumes
CONTAINER_NAME="portainer"
VOLUME_PATH="/opt/szilardshomelab/appdata/portainer/portainer"

# Stop and remove the Portainer container
echo "Stopping and removing the Portainer container..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

# Remove the Portainer volumes
echo "Removing the Portainer volumes..."
sudo rm -rf "$VOLUME_PATH"
# Verify removal
echo "Verifying removal..."
docker ps -a | grep $CONTAINER_NAME
docker volume ls | grep $(basename $VOLUME_PATH)

echo "Portainer has been successfully uninstalled."