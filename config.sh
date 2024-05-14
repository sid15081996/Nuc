#!/bin/bash

#add wifi
sudo nmcli device wifi connect Graviton\ 5G password '&aV*i@T%$n'

# Take user input for firstname and first.name
read -p "Enter fullname: (Ex. siddharthdubey) " fullname
read -p "Enter first.name: (Ex. siddharth.dubey) " firstdotname

# Set root password to 'P@ss'
echo "root:P@ss" | chpasswd

# Move firstname directory to first.name
cd /home || exit
mv "$fullname" "$firstdotname"


# Change permissions of first.name directory
chmod 700 "$firstdotname"

# Update apt and install openssh-server
apt update
apt install -y openssh-server
apt-get install -y gnome-system-tools

# Change PermitRootLogin to 'yes' in sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config


# Replace firstname with first.name in passwd and shadow
sed -i "s/$fullname/$firstdotname/g" /etc/passwd /etc/shadow

# Change ownership of user's directory
cd /home || exit
chown "$firstdotname":users "$firstdotname"

# Mask sleep.target
systemctl mask sleep.target

# Add '#' in front of 'auth required pam_success_if' line in gdm-password file
sed -i 's/auth required pam_success_if/# auth required pam_success_if/' /etc/pam.d/gdm-password   

#note MAC Address
ip addr show | grep ether

#note Serial No.
dmidecode -s system-serial-number
