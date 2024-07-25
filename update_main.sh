#!/bin/bash

# Welcome message
echo "Welcome to SZILARDSHOMELAB!"
echo "Starting the update script..."

# Log file
LOG_FILE="/opt/update.log"

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
    
    # Pull the latest changes and capture output
    echo "$(date): Running git pull..." >> "$LOG_FILE"
    PULL_OUTPUT=$(git pull origin main 2>&1)
    PULL_EXIT_CODE=$?

    echo "$(date): git pull output: $PULL_OUTPUT" >> "$LOG_FILE"

    if [ $PULL_EXIT_CODE -eq 0 ]; then
        if [[ $PULL_OUTPUT == *"Already up to date."* ]]; then
            echo "Repository is already up to date."
            echo "$(date): Repository is already up to date." >> "$LOG_FILE"
        else
            echo "Update successful."
            echo "$(date): Update successful." >> "$LOG_FILE"
        fi

        # Find all .sh files and make them executable
        echo "$(date): Making all .sh files in $TARGET_DIR executable." >> "$LOG_FILE"
        find "$TARGET_DIR" -type f -name "*.sh" -exec chmod +x {} \;
        if [ $? -ne 0 ]; then
            echo "$(date): Failed to make some .sh files executable." >> "$LOG_FILE"
            exit 1
        fi
    else
        echo "Update failed."
        echo "$(date): Update failed." >> "$LOG_FILE"
        exit 1
    fi
else
    echo "Target directory does not exist. Please clone the repository first."
    echo "$(date): Target directory does not exist. Please clone the repository first." >> "$LOG_FILE"
    exit 1
fi

clear
"$TARGET_DIR/menu/menu.sh"
if [ $? -ne 0 ]; then
    echo "$(date): menu.sh execution failed." >> "$LOG_FILE"
    exit 1
fi

# End logging
echo "$(date): Update script finished." >> "$LOG_FILE"