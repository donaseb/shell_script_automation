#!/bin/bash

# Define source and destination
SRC_DIR="/var/www/html/"
DEST_DIR="user@destination_server:/var/www/html/"

# Synchronize files using rsync
rsync -avz --delete $SRC_DIR $DEST_DIR

# Print a message when sync is complete
echo "File synchronization completed."
