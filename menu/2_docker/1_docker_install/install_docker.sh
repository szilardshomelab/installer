#!/bin/bash

# Log file path
LOG_FILE="/opt/logs/docker_install.log"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a $LOG_FILE > /dev/null
}

# Update package list and install required packages
log "Updating package list..."
sudo apt-get update -y | sudo tee -a $LOG_FILE
log "Installing ca-certificates and curl..."
sudo apt-get install -y ca-certificates curl | sudo tee -a $LOG_FILE

# Setup Docker repository and keyring
log "Setting up Docker repository and keyring..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to Apt sources
log "Adding Docker repository to Apt sources..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker packages
log "Updating package list again..."
sudo apt-get update -y | sudo tee -a $LOG_FILE
log "Installing Docker packages..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin | sudo tee -a $LOG_FILE
sudo apt-get install -y docker-compose | sudo tee -a $LOG_FILE

# Add current user to the docker group
log "Adding current user to the docker group..."
sudo usermod -aG docker $USER
log "Please log out and log back in to apply the user group changes."

# Create /opt/appdata/ directory
log "Creating /opt/appdata/ directory..."
sudo mkdir -p /opt/appdata/

# Get USER_ID and GROUP_ID as the current user, not as root
log "Getting USER_ID and GROUP_ID for the current user..."
CURRENT_USER=$(logname)
USER_ID=$(sudo -u $CURRENT_USER id -u)
GROUP_ID=$(sudo -u $CURRENT_USER id -g)

# Write USER_ID and GROUP_ID to the .env file
log "Writing USER_ID and GROUP_ID to the .env file..."
{
    echo "USER_ID=$USER_ID"
    echo "GROUP_ID=$GROUP_ID"
} | sudo tee /opt/appdata/.env > /dev/null

# Set timezone using dpkg-reconfigure tzdata
log "Reconfiguring timezone..."
sudo dpkg-reconfigure tzdata

# Get the current timezone and write to .env file
CURRENT_TIMEZONE=$(cat /etc/timezone)
log "Setting current timezone to $CURRENT_TIMEZONE..."
echo "TIMEZONE=$CURRENT_TIMEZONE" | sudo tee -a /opt/appdata/.env > /dev/null
log "Timezone successfully set to $CURRENT_TIMEZONE."
log "Timezone has been written to /opt/appdata/.env."

# Prompt user for Docker network name with default option
read -p "Please create Docker network proxy (default: szilardshomelab-proxy): " network_name
network_name=${network_name:-szilardshomelab-proxy}

# Create Docker network
log "Creating Docker network with name $network_name..."
if sudo docker network create $network_name; then
    log "Docker network '$network_name' created successfully."
    echo "DOCKER_NETWORK_NAME=$network_name" | sudo tee /opt/appdata/.network.env > /dev/null
    log "Network name saved to /opt/appdata/.network.env."
else
    log "Failed to create Docker network '$network_name'."
    exit 1
fi