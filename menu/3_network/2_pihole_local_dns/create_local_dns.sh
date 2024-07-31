#!/bin/bash

# Define variables
CONTAINER_NAME="pihole"
CONTAINER_PATH="/etc/pihole/setupVars.conf"
ENV_FILE_PATH="/opt/appdata/pihole/.api.env"

# Create the environment file directory if it doesn't exist
mkdir -p "$(dirname "$ENV_FILE_PATH")"

# Extract the API key from the Pi-hole container
API_KEY=$(sudo docker exec "$CONTAINER_NAME" awk -F'=' '/^API_KEY/ {print $2}' "$CONTAINER_PATH")

# Check if API_KEY was found and not empty
if [ -z "$API_KEY" ]; then
  echo "Error: API_KEY not found in $CONTAINER_PATH"
  exit 1
fi

# Write the API key to the environment file
echo "PIHOLE_API_KEY=$API_KEY" > "$ENV_FILE_PATH"

# Provide feedback
echo "API key written to $ENV_FILE_PATH"