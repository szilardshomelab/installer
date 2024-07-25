#!/bin/bash

# Welcome message
echo "Welcome to SZILARDSHOMELAB!"
echo "Starting the script..."

# Log file
LOG_FILE="/opt/logs/clone.log"

# Target directory
TARGET_DIR="/opt/szilardshomelab"

# Start logging
echo "$(date): Script started." >> "$LOG_FILE"
echo "$(date): Welcome to SZILARDSHOMELAB!" >> "$LOG_FILE"
echo "Cloning in progress..."
echo "$(date): Cloning in progress..." >> "$LOG_FILE"
git clone https://github.com/szilardshomelab/installer.git "$TARGET_DIR" &> /dev/null

/opt/szilardshomelab/menu/menu.sh
# End logging
echo "$(date): Script finished." >> "$LOG_FILE"