#!/bin/bash

# Take user input for firstname and first.name
read -p "Enter firstname: " firstname
read -p "Enter first.name: " firstdotname

# Set root password to 'P@ss'
echo "root:P@ss" | chpasswd

# Move firstname directory to first.name
cd /home || exit
mv "$firstname" "$firstdotname"

# Change ownership of user's directory
chown "$firstdotname":users "$firstdotname"

# Change permissions of first.name directory
chmod 700 "$firstdotname"

# Update apt and install openssh-server
apt update
apt install -y openssh-server

# Change PermitRootLogin to 'yes' in sshd_config
sed -i 's/PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config


# Replace firstname with first.name in passwd and shadow
sed -i "s/$firstname/$firstdotname/g" /etc/passwd /etc/shadow

# Mask sleep.target
systemctl mask sleep.target

# Add '#' in front of 'auth required pam_success_if' line in gdm-password file
sed -i 's/auth required pam_success_if/# auth required pam_success_if/' /etc/pam.d/gdm-password