#!/bin/bash

# Define variables
CONTAINER_NAME="pihole"
CONTAINER_PATH="/etc/pihole/setupVars.conf"
ENV_FILE_PATH="/opt/appdata/pihole/.api.env"

# Create the environment file directory if it doesn't exist
mkdir -p "$(dirname "$ENV_FILE_PATH")"

# Extract the WEBPASSWORD from the Pi-hole container
WEBPASSWORD=$(sudo docker exec "$CONTAINER_NAME" awk -F'=' '/^WEBPASSWORD/ {print $2}' "$CONTAINER_PATH")

# Check if WEBPASSWORD was found and not empty
if [ -z "$WEBPASSWORD" ]; then
  echo "Error: WEBPASSWORD not found in $CONTAINER_PATH"
  exit 1
fi

# Write the WEBPASSWORD to the environment file
echo "PIHOLE_API_KEY=$WEBPASSWORD" > "$ENV_FILE_PATH"

# Provide feedback
echo "API key written to $ENV_FILE_PATH"