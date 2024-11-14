#!/bin/bash

# Get user details
read -p "Enter username: " USERNAME
read -sp "Enter password: " PASSWORD
echo

# Create the user and set the password
sudo useradd -m $USERNAME
echo "$USERNAME:$PASSWORD" | sudo chpasswd

# Set default permissions
sudo chmod 700 /home/$USERNAME

echo "User $USERNAME created successfully."
