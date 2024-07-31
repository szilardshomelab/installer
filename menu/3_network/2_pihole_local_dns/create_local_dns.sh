#!/bin/bash

# Part 1: Extract API key from Pi-hole Docker container and write to .api.env

# Define variables for extracting API key
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

# Part 2: Use the API key to create a local DNS record

# Load the API key from the environment file
source "$ENV_FILE_PATH"

# Check if the API key was loaded
if [ -z "$PIHOLE_API_KEY" ]; then
  echo "Error: PIHOLE_API_KEY not found in $ENV_FILE_PATH"
  exit 1
fi
SERVER_IP=$(hostname -I | awk '{print $1}')
# Define the Pi-hole URL
PIHOLE_URL="http://$SERVER_IP/admin/api.php"

# Check if DOMAIN argument is provided
if [ -z "$1" ]; then
  echo "Error: No domain provided. Usage: $0 SOMETHING.local"
  exit 1
fi

DOMAIN="$1"



# Check if SERVER_IP was obtained
if [ -z "$SERVER_IP" ]; then
  echo "Error: Could not determine server IP address."
  exit 1
fi

# Create the local DNS record using the Pi-hole API
response=$(curl -s -G \
  --data-urlencode "list=localdns" \
  --data-urlencode "json" \
  --data-urlencode "record=$DOMAIN" \
  --data-urlencode "ip=$SERVER_IP" \
  --data-urlencode "auth=$PIHOLE_API_KEY" \
  "$PIHOLE_URL")

# Check the response
if echo "$response" | grep -q '"success":true'; then
  echo "Local DNS record for $DOMAIN -> $SERVER_IP created successfully."
else
  echo "Error: Failed to create local DNS record. Response: $response"
  exit 1
fi