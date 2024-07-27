#!/bin/bash

# Update package list and install required packages
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo apt-get install docker-compose -y
sudo usermod -aG docker $USER
sudo mkdir -p /opt/appdata
# Get USER_ID and GROUP_ID as the current user, not as root
CURRENT_USER=$(logname)
USER_ID=$(sudo -u $CURRENT_USER id -u)
GROUP_ID=$(sudo -u $CURRENT_USER id -g)

# Write USER_ID and GROUP_ID to the .env file
{
    echo "USER_ID=$USER_ID"
    echo "GROUP_ID=$GROUP_ID"
} | sudo tee /opt/appdata/.env > /dev/null

# Set timezone using dpkg-reconfigure tzdata
sudo dpkg-reconfigure tzdata

# Get the current timezone and write to .env file
CURRENT_TIMEZONE=$(cat /etc/timezone)
echo "TIMEZONE=$CURRENT_TIMEZONE" | sudo tee -a /opt/appdata/.env > /dev/null
echo "Timezone successfully set to $CURRENT_TIMEZONE."
echo "Timezone has been written to /opt/appdata/.env."

# Prompt user for Docker network name with default option
read -p "Please create Docker network proxy (default: szilardshomelab-proxy): " network_name
network_name=${network_name:-szilardshomelab-proxy}

# Create Docker network
sudo docker network create $network_name

# Write Docker network name to the .env file
echo "DOCKER_NETWORK_NAME=$network_name" | sudo tee -a /opt/appdata/.network.env > /dev/null

echo "Docker network '$network_name' created successfully."
echo "Network name saved to /opt/appdata/.network.env."