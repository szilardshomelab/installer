#!/bin/bash

# Welcome message
echo "Welcome to SZILARDSHOMELAB!"
echo "Starting the script..."

# Log file
LOG_FILE="/opt/clone.log"

# Target directory
TARGET_DIR="/opt/szilardshomelab"

# Start logging
echo "$(date): Script started." >> "$LOG_FILE"
echo "$(date): Welcome to SZILARDSHOMELAB!" >> "$LOG_FILE"
echo "Cloning in progress..."
echo "$(date): Cloning in progress..." >> "$LOG_FILE"

# Ensure the target directory exists or create it
if [ ! -d "$TARGET_DIR" ]; then
  echo "$(date): Creating target directory $TARGET_DIR." >> "$LOG_FILE"
  mkdir -p "$TARGET_DIR"
  if [ $? -ne 0 ]; then
    echo "$(date): Failed to create target directory $TARGET_DIR." >> "$LOG_FILE"
    exit 1
  fi
fi

# Perform git clone and check for errors
git clone https://github.com/szilardshomelab/installer.git "$TARGET_DIR" &>> "$LOG_FILE"
if [ $? -ne 0 ]; then
  echo "$(date): Git clone failed." >> "$LOG_FILE"
  exit 1
fi

# Find all .sh files and make them executable
echo "$(date): Making all .sh files in $TARGET_DIR executable." >> "$LOG_FILE"
find "$TARGET_DIR" -type f -name "*.sh" -exec chmod +x {} \;
if [ $? -ne 0 ]; then
  echo "$(date): Failed to make some .sh files executable." >> "$LOG_FILE"
  exit 1
fi

# Check if menu.sh exists and is executable
MENU_SCRIPT="$TARGET_DIR/menu/menu.sh"
if [ ! -f "$MENU_SCRIPT" ]; then
  echo "$(date): $MENU_SCRIPT not found." >> "$LOG_FILE"
  exit 1
fi

if [ ! -x "$MENU_SCRIPT" ]; then
  echo "$(date): $MENU_SCRIPT is not executable." >> "$LOG_FILE"
  exit 1
fi

# Run the menu script
"$MENU_SCRIPT"
if [ $? -ne 0 ]; then
  echo "$(date): $MENU_SCRIPT execution failed." >> "$LOG_FILE"
  exit 1
fi

# End logging
echo "$(date): Script finished." >> "$LOG_FILE"