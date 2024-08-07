#!/bin/bash

# Welcome message
echo "Welcome to SZILARDSHOMELAB!"
echo "Starting the script..."

# Log file
LOG_FILE="/opt/logs/clone_repo.log"

# Ensure the logs directory exists
mkdir -p /opt/logs

# Remove the target directory if it exists
TARGET_DIR="/opt/szilardshomelab"
if [ -d "$TARGET_DIR" ]; then
    sudo rm -rf "$TARGET_DIR"
    if [ $? -eq 0 ]; then
        echo "Existing $TARGET_DIR removed successfully." | tee -a "$LOG_FILE"
        echo "$(date): Existing $TARGET_DIR removed successfully." >> "$LOG_FILE"
    else
        echo "Failed to remove existing $TARGET_DIR." | tee -a "$LOG_FILE"
        echo "$(date): Failed to remove existing $TARGET_DIR." >> "$LOG_FILE"
        exit 1
    fi
fi

# Target directory
REPO_URL="https://github.com/szilardshomelab/installer.git"
BRANCH="main"

# Start logging
echo "$(date): Script started." >> "$LOG_FILE"
echo "$(date): Welcome to SZILARDSHOMELAB!" >> "$LOG_FILE"

# Ensure Git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Installing Git..." | tee -a "$LOG_FILE"
    sudo apt-get update >> "$LOG_FILE" 2>&1
    sudo apt-get install git -y >> "$LOG_FILE" 2>&1
fi

# Clone the Git repo
echo "Cloning the repository..." | tee -a "$LOG_FILE"
git clone --branch "$BRANCH" "$REPO_URL" "$TARGET_DIR" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "Repository cloned successfully." | tee -a "$LOG_FILE"
    echo "$(date): Repository cloned successfully." >> "$LOG_FILE"
else
    echo "Failed to clone the repository." | tee -a "$LOG_FILE"
    echo "$(date): Failed to clone the repository." >> "$LOG_FILE"
    exit 1
fi

# Set execution permissions for all .sh files in the target directory
echo "Setting execution permissions for all .sh files..." | tee -a "$LOG_FILE"
find "$TARGET_DIR" -type f -name "*.sh" -exec chmod +x {} \; >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "Execution permissions set successfully." | tee -a "$LOG_FILE"
    echo "$(date): Execution permissions set successfully." >> "$LOG_FILE"
else
    echo "Failed to set execution permissions." | tee -a "$LOG_FILE"
    echo "$(date): Failed to set execution permissions." >> "$LOG_FILE"
    exit 1
fi

# Set ownership and permissions for the directories
directories=(
    "/opt/appdata"
    "/opt/szilardshomelab"
    "/opt/logs"
)

# Change ownership to ubuntu
for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        sudo chown -R ubuntu:ubuntu "$dir"
        echo "Changed ownership of $dir to ubuntu:ubuntu" | tee -a "$LOG_FILE"
    else
        echo "$dir does not exist." | tee -a "$LOG_FILE"
    fi
done

# Set full permissions (read, write, execute for owner, group, and others)
for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        sudo chmod -R 777 "$dir"
        echo "Set full permissions for $dir" | tee -a "$LOG_FILE"
    else
        echo "$dir does not exist." | tee -a "$LOG_FILE"
    fi
done

# Ensure /opt/appdata/traefik directory exists
TRAFFIC_DIR="/opt/appdata/traefik"
if [ -d "$TRAFFIC_DIR" ]; then
    # Set permissions for acme.json file if it exists
    ACME_FILE="$TRAFFIC_DIR/acme.json"
    if [ -f "$ACME_FILE" ]; then
        sudo chmod 600 "$ACME_FILE"
        echo "Set permissions for $ACME_FILE to 600" | tee -a "$LOG_FILE"
    else
        echo "$ACME_FILE does not exist." | tee -a "$LOG_FILE"
    fi
else
    echo "$TRAFFIC_DIR does not exist." | tee -a "$LOG_FILE"
fi

# End logging
echo "$(date): Script finished." >> "$LOG_FILE"

# Clear the screen and execute the menu script
clear
"$TARGET_DIR/menu/menu.sh"

# Check if menu.sh execution was successful
if [ $? -ne 0 ]; then
    echo "$(date): menu.sh execution failed." >> "$LOG_FILE"
    exit 1
fi