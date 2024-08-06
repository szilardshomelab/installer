#!/bin/bash

# Prompt the user to confirm installation
while true; do
    read -p "Are you sure you want to install PiHole? (y/n): " CONFIRM
    case "$CONFIRM" in
        [yY]* ) 
            # Prompt for PiHole password and append it to the .env file
            read -sp "Please enter a strong password for the PiHole WEBUI: " PIHOLE_PASSWORD
            echo
            echo "PIHOLE_PASSWORD=$PIHOLE_PASSWORD" >> /opt/appdata/.env
            break;;  # If 'y' or 'Y' is input, proceed
        [nN]* ) 
            echo "Installation aborted."
            exit 1;;  # If 'n' or 'N' is input, exit
        * ) 
            echo "Please choose 'y' or 'n'.";;  # If not 'y' or 'n', prompt again
    esac
done

# Adjust DNS resolution settings
sudo sed -r -i.orig 's/#?DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf
sudo sh -c 'rm /etc/resolv.conf && ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf'
sudo systemctl restart systemd-resolved

# Define file paths
NETWORK_ENV_FILE="/opt/appdata/.network.env"
TEMPLATE_FILE="/opt/szilardshomelab/appdata/pihole/compose-template.yml"
OUTPUT_FILE="/opt/appdata/pihole/compose.yml"

# Create necessary directories and files
mkdir -p /opt/appdata/pihole
touch $OUTPUT_FILE

# Load environment variables from the .network.env file
if [ -f "$NETWORK_ENV_FILE" ]; then
    export $(grep -v '^#' $NETWORK_ENV_FILE | xargs)
else
    echo "Error: Network environment file not found: $NETWORK_ENV_FILE"
    exit 1
fi

# Check if DOCKER_NETWORK_NAME is set
if [ -z "${DOCKER_NETWORK_NAME}" ]; then
    echo "Error: DOCKER_NETWORK_NAME is not set in $NETWORK_ENV_FILE"
    exit 1
fi

# Substitute variables in the template and generate the docker-compose.yml
sed "s|__DOCKER_NETWORK_NAME__|${DOCKER_NETWORK_NAME}|g" $TEMPLATE_FILE > $OUTPUT_FILE

# Start Docker Compose services
sudo docker compose -f $OUTPUT_FILE --env-file /opt/appdata/.env up -d

# Check if the Docker Compose command was successful
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to start PiHole service"
  exit 1
fi

echo "PiHole service started successfully"

# Get the server's IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

# Assuming PiHole is exposed on port 500
pihole_PORT=500

# Construct the access URL
ACCESS_URL="http://$SERVER_IP:$pihole_PORT/admin"

echo "Access PiHole at: $ACCESS_URL"