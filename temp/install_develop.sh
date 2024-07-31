#!/bin/bash

# Welcome message
echo "Welcome to SZILARDSHOMELAB!"
echo "Starting the script..."

# Log file
LOG_FILE="/opt/logs/clone_repo.log"

# Ensure the logs directory exists
mkdir -p /opt/logs

# Target directory
TARGET_DIR="/opt/szilardshomelab"
REPO_URL="https://github.com/szilardshomelab/installer.git"
BRANCH="develop"

# Start logging
echo "$(date): Script started." >> "$LOG_FILE"
echo "$(date): Welcome to SZILARDSHOMELAB!" >> "$LOG_FILE"

# Ensure Git is installed
if ! command -v git &> /dev/null
then
    echo "Git is not installed. Installing Git..." | tee -a "$LOG_FILE"
    sudo apt-get update >> "$LOG_FILE" 2>&1
    sudo apt-get install git -y >> "$LOG_FILE" 2>&1
fi

# Check if the target directory is a Git repository
if [ -d "$TARGET_DIR/.git" ]; then
    echo "The target directory already exists and is a git repository. Stashing local changes..." | tee -a "$LOG_FILE"
    cd "$TARGET_DIR" || { echo "$(date): Failed to navigate to $TARGET_DIR." >> "$LOG_FILE"; exit 1; }
    
    git stash >> "$LOG_FILE" 2>&1
    git pull origin "$BRANCH" >> "$LOG_FILE" 2>&1
    git stash pop >> "$LOG_FILE" 2>&1
    
    if [ $? -eq 0 ]; then
        echo "Repository updated successfully."
        echo "$(date): Repository updated successfully." >> "$LOG_FILE"
    else
        echo "An error occurred during updating."
        echo "$(date): An error occurred during updating." >> "$LOG_FILE"
        exit 1
    fi
else
    # Clone the Git repo
    echo "Cloning the repository..." | tee -a "$LOG_FILE"
    git clone --branch "$BRANCH" "$REPO_URL" "$TARGET_DIR" >> "$LOG_FILE" 2>&1
    
    if [ $? -eq 0 ]; then
        echo "Repository cloned successfully."
        echo "$(date): Repository cloned successfully." >> "$LOG_FILE"
    else
        echo "Failed to clone the repository."
        echo "$(date): Failed to clone the repository." >> "$LOG_FILE"
        exit 1
    fi
fi

# Set execution permissions for all .sh files in the target directory
echo "Setting execution permissions for all .sh files..." | tee -a "$LOG_FILE"
find "$TARGET_DIR" -type f -name "*.sh" -exec chmod +x {} \; >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "Execution permissions set successfully."
    echo "$(date): Execution permissions set successfully." >> "$LOG_FILE"
else
    echo "Failed to set execution permissions."
    echo "$(date): Failed to set execution permissions." >> "$LOG_FILE"
    exit 1
fi

# Clear the screen and execute the menu script
clear
"$TARGET_DIR/menu/menu.sh"

# Check if menu.sh execution was successful
if [ $? -ne 0 ]; then
    echo "$(date): menu.sh execution failed." >> "$LOG_FILE"
    exit 1
fi

# End logging
echo "$(date): Script finished." >> "$LOG_FILE"