#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root (use sudo)"
  exit
fi

CURRENT_USER=$(whoami)

echo "--- Starting System Cleanup ---"

# 1. Identify and delete all other human users
# Typically, human users have UIDs >= 1000
for user in $(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd); do
    if [ "$user" != "$CURRENT_USER" ]; then
        echo "Deleting user and data: $user"
        userdel -r "$user" 2>/dev/null
    fi
done

# 2. Clear common shared data areas (optional but recommended for 'fresh' feel)
echo "Clearing temporary files and caches..."
rm -rf /tmp/*
rm -rf /var/tmp/*
apt-get clean

# 3. Create 'bs_thesis' (Sudo Admin)
echo "Creating user: bs_thesis..."
useradd -m -s /bin/bash bs_thesis
echo "bs_thesis:BS_UG@123" | chpasswd
usermod -aG sudo bs_thesis

# 4. Create 'dse_uglab_admin' (Sudo Admin)
echo "Creating user: dse_uglab_admin..."
useradd -m -s /bin/bash dse_uglab_admin
echo "dse_uglab_admin:DsE@LaB*!1_PC" | chpasswd
usermod -aG sudo dse_uglab_admin

# 5. Create 'Guest' (Standard User)
echo "Creating user: Guest..."
useradd -m -s /bin/bash Guest
echo "Guest:uglab" | chpasswd

echo "--- Setup Complete ---"
echo "Admins: bs_thesis, dse_uglab_admin"
echo "Standard: Guest"
