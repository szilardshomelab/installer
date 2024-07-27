#!/bin/bash

# Prompt the user to confirm installation
while true; do
    read -p "Are you sure you want to install qBittorrent? (y/n): " CONFIRM
    case "$CONFIRM" in
        [yY]* ) break;;   # If 'y' or 'Y' is input, proceed
        [nN]* ) echo "Installation aborted."; exit 1;;  # If 'n' or 'N' is input, exit
        * ) echo "Please choose 'y' or 'n'."; # If not 'y' or 'n', prompt again
    esac
done

# Update the .env file
ENV_FILE="/opt/appdata/.env"

# Check if the entry already exists
if grep -q '^SMB=' "$ENV_FILE"; then
    sudo sed -i "s/^SMB=.*/SMB=$SMB_PATH/" "$ENV_FILE"
else
    echo "SMB=$SMB_PATH" | sudo tee -a "$ENV_FILE" > /dev/null
fi
ENV_FILE2="/opt/appdata/.network.env"
TEMPLATE_FILE="/opt/szilardshomelab/appdata/qbittorrent/compose-template.yml"
mkdir -p /opt/appdata/qbittorrent
touch /opt/appdata/qbittorrent/compose.yml
OUTPUT_FILE="/opt/appdata/qbittorrent/compose.yml"

# Load environment variables from the .network.env file
if [ -f "$ENV_FILE2" ]; then
    export $(grep -v '^#' $ENV_FILE2 | xargs)
else
    echo "Error: Network environment file not found: $ENV_FILE2"
    exit 1
fi

# Check if DOCKER_NETWORK_NAME is set
if [ -z "${DOCKER_NETWORK_NAME}" ]; then
    echo "Error: DOCKER_NETWORK_NAME is not set in $ENV_FILE2"
    exit 1
fi

# Substitute variables in the template and generate the docker-compose.yml
sed "s|__DOCKER_NETWORK_NAME__|${DOCKER_NETWORK_NAME}|g" $TEMPLATE_FILE > $OUTPUT_FILE

echo "Starting the qBittorrent service..."
# Start Docker Compose services
sudo docker compose -f $OUTPUT_FILE --env-file $ENV_FILE up -d

# Check if the Docker Compose command was successful
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to start qBittorrent service"
  exit 1
fi

echo "qBittorrent service started successfully"

# Wait for the container to be fully started (increase the sleep duration if needed)
sleep 5

# Stop the container
echo "Stopping the qBittorrent container..."
sudo docker compose -f $OUTPUT_FILE --env-file $ENV_FILE down -d

# Check if the configuration file exists
CONFIG_FILE="/opt/appdata/qbittorrent/config/qBittorrent/qBittorrent.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file not found at $CONFIG_FILE."
    exit 1
fi

# Modify the configuration file
echo "Modifying the qBittorrent configuration file..."
sudo sed -i 's|Downloads\\SavePath=/downloads|Downloads\\SavePath=/data/torrents|g' "$CONFIG_FILE"
sudo sed -i 's|Session\\DefaultSavePath=/downloads|Session\\DefaultSavePath=/data/torrents|g' "$CONFIG_FILE"

if [[ $? -ne 0 ]]; then
  echo "Error: Failed to modify the configuration file."
  exit 1
fi

echo "Configuration file modified successfully."

# Start the container again
echo "Restarting the qBittorrent container..."
sudo docker compose -f $OUTPUT_FILE --env-file $ENV_FILE up -d

# Check if the Docker Compose command was successful
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to restart qBittorrent service."
  exit 1
fi

echo "qBittorrent service restarted successfully with updated configuration."

# Wait for the container to be fully started (increase the sleep duration if needed)
sleep 5
# Get the container ID or name
CONTAINER_ID=$(sudo docker ps -q -f "name=qbittorrent") # Adjust filter if necessary

if [ -z "$CONTAINER_ID" ]; then
  echo "Error: Unable to find the qBittorrent container."
  exit 1
fi
# Retrieve logs from the container and extract the temporary password
TEMP_PASSWORD=$(sudo docker logs "$CONTAINER_ID" 2>&1 | grep -oP '(?<=The WebUI administrator password was not set. A temporary password is provided for this session: )[^\s]*')

if [ -z "$TEMP_PASSWORD" ]; then
  echo "Error: Unable to retrieve the temporary password."
  exit 1
fi

# Get the server's IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

# Assuming qBittorrent is exposed on port 8080
QBITTORRENT_PORT=8080

# Construct the access URL
ACCESS_URL="http://$SERVER_IP:$QBITTORRENT_PORT"

echo "Access qBittorrent at: $ACCESS_URL"
echo "Temporary WebUI administrator password: $TEMP_PASSWORD"