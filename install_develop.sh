#!/bin/bash

# Welcome message
echo "Welcome to SZILARDSHOMELAB!"
echo "Starting the script..."

# Log file
LOG_FILE="/opt/szilardshomelab_clone.log"

# Target directory
TARGET_DIR="/opt/szilardshomelab"

# Start logging
echo "$(date): Script started." >> "$LOG_FILE"
echo "$(date): Welcome to SZILARDSHOMELAB!" >> "$LOG_FILE"

# Check if the target directory exists
if [ -d "$TARGET_DIR/.git" ]; then
  echo "The target directory already exists and is a git repository. Stashing local changes..."
  echo "$(date): The target directory already exists and is a git repository. Stashing local changes..." >> "$LOG_FILE"
  cd "$TARGET_DIR"
  git stash 
  git pull 
  git stash pop 
else
  # Clone the Git repo
  echo "Cloning in progress..."
  echo "$(date): Cloning in progress..." >> "$LOG_FILE"
  git clone https://github.com/szilardshomelab/installer/develop.git "$TARGET_DIR" &> /dev/null
fi

# Check if the cloning or pulling was successful
if [ $? -eq 0 ]; then
  echo "Repository is up to date."
  echo "$(date): Repository is up to date." >> "$LOG_FILE"

  # Set execution permissions for all .sh files in the target directory
  echo "Setting execution permissions for all .sh files..."
  echo "$(date): Setting execution permissions for all .sh files..." >> "$LOG_FILE"
  find "$TARGET_DIR" -type f -name "*.sh" -exec chmod +x {} \; &> /dev/null

  echo "Execution permissions set successfully."
  echo "$(date): Execution permissions set successfully." >> "$LOG_FILE"
else
  echo "An error occurred during cloning or pulling."
  echo "$(date): An error occurred during cloning or pulling." >> "$LOG_FILE"
fi
clear
/opt/szilardshomelab/menu/menu.sh
# End logging
echo "$(date): Script finished." >> "$LOG_FILE"