#!/bin/bash

# Ask the user to confirm the installation
while true; do
    read -p "Are you sure you want to install Portainer? (y/n): " CONFIRM
    case "$CONFIRM" in
        [yY]* ) break;;   # If 'y' or 'Y', proceed
        [nN]* ) echo "Installation aborted."; exit 1;;  # If 'n' or 'N', exit
        * ) echo "Please choose 'y' or 'n'."; # If not 'y' or 'n', ask again
    esac
done

# Define the paths
ENV_FILE="/opt/szilardshomelab/.env"
TEMPLATE_FILE="/opt/szilardshomelab/appdata/portainer/compose-template.yml"
OUTPUT_FILE="/opt/szilardshomelab/appdata/portainer/compose.yml"

# Load environment variables from the .env file
export $(grep -v '^#' $ENV_FILE | xargs)

# Substitute variables in the template and generate the docker-compose.yml
envsubst < $TEMPLATE_FILE > $OUTPUT_FILE

# Start Docker Compose services
sudo docker compose -f $OUTPUT_FILE up -d

echo "Docker Compose services started!"

# Get the server's IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

# Assuming Portainer is exposed on port 9000
PORTAINER_PORT=9443

# Construct the access URL
ACCESS_URL="https://$SERVER_IP:$PORTAINER_PORT"

echo "Access Portainer at: $ACCESS_URL"