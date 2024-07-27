#!/bin/bash

# Ask the user to confirm the installation
while true; do
    read -p "Are you sure you want to install prowlarr? (y/n): " CONFIRM
    case "$CONFIRM" in
        [yY]* ) break;;   # If 'y' or 'Y', proceed
        [nN]* ) echo "Installation aborted."; exit 1;;  # If 'n' or 'N', exit
        * ) echo "Please choose 'y' or 'n'."; # If not 'y' or 'n', ask again
    esac
done

# Define the paths
ENV_FILE="/opt/appdata/.network.env"
TEMPLATE_FILE="/opt/szilardshomelab/appdata/prowlarr/compose-template.yml"
mkdir -p /opt/appdata/prowlarr
touch /opt/appdata/prowlarr/compose.yml
OUTPUT_FILE="/opt/appdata/prowlarr/compose.yml"

# Load environment variables from the .env file
export $(grep -v '^#' $ENV_FILE | xargs)

# Substitute variables in the template and generate the docker-compose.yml
sed "s/__DOCKER_NETWORK_NAME__/${DOCKER_NETWORK_NAME}/g" $TEMPLATE_FILE > $OUTPUT_FILE

# Start Docker Compose services
sudo docker compose -f $OUTPUT_FILE up -d

echo "Docker Compose services started!"

# Get the server's IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

# Assuming prowlarr is exposed on port 9000
prowlarr_PORT=9443

# Construct the access URL
ACCESS_URL="https://$SERVER_IP:$prowlarr_PORT"

echo "Access prowlarr at: $ACCESS_URL"