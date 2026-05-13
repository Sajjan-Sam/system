```bash
#!/bin/bash

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

TARGET_USER="bs_thesis"
NEW_PASS="BS_UG@123"

echo "--- Refreshing User: $TARGET_USER ---"

# Kill all running processes of the target user
if id "$TARGET_USER" &>/dev/null; then
    echo "Stopping processes for $TARGET_USER..."
    pkill -KILL -u "$TARGET_USER" 2>/dev/null

    echo "Removing existing user and home directory..."
    userdel -r "$TARGET_USER"
    sleep 2
else
    echo "User does not exist. Creating fresh user..."
fi

# Create fresh user
echo "Creating new user: $TARGET_USER"
useradd -m -s /bin/bash "$TARGET_USER"

# Set password
echo "$TARGET_USER:$NEW_PASS" | chpasswd

# Give sudo access
usermod -aG sudo "$TARGET_USER"

echo "--- Success ---"
echo "User recreated successfully."
echo "Username: $TARGET_USER"
echo "Password: $NEW_PASS"
echo "Sudo access granted."
```
