#!/bin/bash

# Define log file path
LOG_FILE="/opt/logs/create_dns_record.log"

# Create the log file directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Function to log messages with timestamps
log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Part 1: Prompt for confirmation and domain name

# Ask for confirmation
read -p "Are you sure you want to create a local DNS record in Pi-hole? (yes/no): " confirmation

if [ "$confirmation" != "yes" ]; then
  log_message "Operation cancelled."
  exit 0
fi

# Ask for the domain name
read -p "Enter the domain name (e.g., SOMETHING.local): " DOMAIN

# Validate domain name
if [[ ! "$DOMAIN" =~ ^[a-zA-Z0-9.-]+\.local$ ]]; then
  log_message "Error: Invalid domain name. It should end with '.local'."
  exit 1
fi

# Part 2: Extract API key from Pi-hole Docker container and write to .api.env

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
  log_message "Error: WEBPASSWORD not found in $CONTAINER_PATH"
  exit 1
fi

# Write the WEBPASSWORD to the environment file
echo "PIHOLE_API_KEY=$WEBPASSWORD" > "$ENV_FILE_PATH"

# Provide feedback
log_message "API key written to $ENV_FILE_PATH"

# Part 3: Use the API key to create a local DNS record

# Load the API key from the environment file
source "$ENV_FILE_PATH"

# Check if the API key was loaded
if [ -z "$PIHOLE_API_KEY" ]; then
  log_message "Error: PIHOLE_API_KEY not found in $ENV_FILE_PATH"
  exit 1
fi

# Fetch the server IP address dynamically
SERVER_IP=$(hostname -I | awk '{print $1}')

# Check if SERVER_IP was obtained
if [ -z "$SERVER_IP" ]; then
  log_message "Error: Could not determine server IP address."
  exit 1
fi

# Define the Pi-hole URL
PIHOLE_URL="http://$SERVER_IP/admin/api.php"

# Create the local DNS record using the Pi-hole API
response=$(curl -s -G \
  --data-urlencode "list=localdns" \
  --data-urlencode "json" \
  --data-urlencode "record=$DOMAIN" \
  --data-urlencode "ip=$SERVER_IP" \
  --data-urlencode "auth=$PIHOLE_API_KEY" \
  "$PIHOLE_URL")

# Log the raw response for debugging
log_message "Raw response: $response"

# Check the response
if echo "$response" | grep -q '"success":true'; then
  log_message "Local DNS record for $DOMAIN -> $SERVER_IP created successfully."
else
  log_message "Error: Failed to create local DNS record. Response: $response"
  exit 1
fi