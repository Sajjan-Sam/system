#!/bin/bash

# Check for root privileges
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root (use sudo)"
  exit
fi

TARGET_USER="bs_thesis"
NEW_PASS="BS_UG@123"

echo "--- Refreshing User: $TARGET_USER ---"

# 1. Force kill any processes running under the old user to allow deletion
pkill -u "$TARGET_USER"

# 2. Delete the user and their home directory
if id "$TARGET_USER" &>/dev/null; then
    echo "Removing existing $TARGET_USER and clearing data..."
    userdel -r "$TARGET_USER"
    sleep 1 # Small buffer for filesystem cleanup
else
    echo "User $TARGET_USER does not exist. Creating fresh..."
fi

# 3. Create the user fresh
useradd -m -s /bin/bash "$TARGET_USER"

# 4. Set the new password
echo "$TARGET_USER:$NEW_PASS" | chpasswd

# 5. Grant sudo rights
usermod -aG sudo "$TARGET_USER"

echo "--- Success: $TARGET_USER has been reset with the new password ---"
