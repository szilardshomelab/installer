#!/bin/bash

# Define the log file
LOG_FILE="/opt/mount_smb.log"

# Function to log messages
log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
}

# Prompt user for input
read -p "Enter the SMB server IP/Name (e.g., 192.168.1.10 or server_name): " SERVER
read -p "Enter the SMB share name (e.g., share_name): " SHARE_NAME
read -p "Enter the local mount point (e.g., /mnt/share): " MOUNT_POINT
read -p "Enter your SMB username: " USERNAME
read -p "Enter your SMB password: " PASSWORD

# Construct the share path
SHARE="//${SERVER}/${SHARE_NAME}"

# Check if mount point exists, create if not
if [ ! -d "$MOUNT_POINT" ]; then
    log_message "Mount point $MOUNT_POINT does not exist. Creating..."
    sudo mkdir -p "$MOUNT_POINT" >> "$LOG_FILE" 2>&1
fi

# Ensure /etc/samba directory exists
if [ ! -d "/etc/samba" ]; then
    log_message "Creating /etc/samba directory..."
    sudo mkdir -p /etc/samba >> "$LOG_FILE" 2>&1
fi

# Create credentials file
CREDS_FILE="/etc/samba/credentials"
log_message "Creating credentials file $CREDS_FILE..."
{
    echo "username=$USERNAME" | sudo tee "$CREDS_FILE" > /dev/null
    echo "password=$PASSWORD" | sudo tee -a "$CREDS_FILE" > /dev/null
    sudo chmod 600 "$CREDS_FILE"
} >> "$LOG_FILE" 2>&1

# Update /etc/fstab
FSTAB_ENTRY="//$SERVER/$SHARE_NAME $MOUNT_POINT cifs credentials=$CREDS_FILE,uid=$(id -u),gid=$(id -g),vers=3.0 0 0"
if ! grep -q "$FSTAB_ENTRY" /etc/fstab; then
    log_message "Updating /etc/fstab with new entry."
    echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab >> "$LOG_FILE" 2>&1

    # Reload systemd configuration to recognize the updated fstab
    log_message "Reloading systemd configuration to apply changes to /etc/fstab."
    sudo systemctl daemon-reload >> "$LOG_FILE" 2>&1
fi

# Attempt to mount the SMB share
log_message "Mounting $SHARE to $MOUNT_POINT"
{
    sudo mount -a
} >> "$LOG_FILE" 2>&1

# Check if the mount was successful
if mountpoint -q "$MOUNT_POINT"; then
    log_message "Successfully mounted $SHARE to $MOUNT_POINT"
else
    log_message "Failed to mount $SHARE to $MOUNT_POINT. Attempting manual mount for debugging."

    # Attempt a manual mount for troubleshooting
    {
        sudo mount -t cifs "$SHARE" "$MOUNT_POINT" -o credentials="$CREDS_FILE",vers=3.0
    } >> "$LOG_FILE" 2>&1

    # Log detailed system messages
    log_message "Checking system messages for more details."
    sudo dmesg | grep CIFS >> "$LOG_FILE"
    sudo journalctl -xe | grep CIFS >> "$LOG_FILE"
    
    exit 1
fi

log_message "Script execution completed."