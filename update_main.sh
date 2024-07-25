#!/bin/bash

# Welcome message
echo "Welcome to SZILARDSHOMELAB!"
echo "Starting the update script..."

# Log file
LOG_FILE="/opt/logs/update.log"

# Target directory
TARGET_DIR="/opt/szilardshomelab"

# Start logging
echo "$(date): Update script started." >> "$LOG_FILE"
echo "$(date): Welcome to SZILARDSHOMELAB!" >> "$LOG_FILE"
echo "Updating in progress..."
echo "$(date): Updating in progress..." >> "$LOG_FILE"

# Check if the target directory exists
if [ -d "$TARGET_DIR" ]; then
    # Navigate to the repository directory
    cd "$TARGET_DIR"
    # Pull the latest changes
    git pull origin main &> /dev/null

    if [ $? -eq 0 ]; then
        echo "Update successful."
        echo "$(date): Update successful." >> "$LOG_FILE"
    else
        echo "Update failed."
        echo "$(date): Update failed." >> "$LOG_FILE"
    fi
else
    echo "Target directory does not exist. Please clone the repository first."
    echo "$(date): Target directory does not exist. Please clone the repository first." >> "$LOG_FILE"
fi

clear
/opt/szilardshomelab/menu/menu.sh

# End logging
echo "$(date): Update script finished." >> "$LOG_FILE"