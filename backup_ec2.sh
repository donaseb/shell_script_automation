#!/bin/bash
#!/bin/bash

# Configuration
SOURCE_DIR="/home/ubuntu/source/sfile"                # Directory on the source EC2 instance to back up
BACKUP_DIR="/tmp/backups"                       # Temporary local directory to store the compressed backup
DESTINATION_USER="ubuntu"                     # Username for SSH access on the destination EC2 instance
DESTINATION_IP="XX.XX.XX.XX"                    # Public IP address of the destination EC2 instance
DESTINATION_DIR="/home/ubuntu/backups"        # Directory on the destination EC2 instance to store the backup
SOURCE_KEY_PATH="/path/to/source-instance-key.pem" # Path to the private key for the source EC2 instance
DESTINATION_KEY_PATH="/path/to/destination-instance-key.pem" # Path to the private key for the destination EC2 instance
LOG_FILE="/var/log/ec2_backup.log"               # Log file for backup progress
DATE=$(date '+%Y-%m-%d_%H-%M-%S')                # Date format for backup filenames
BACKUP_NAME="backup_$DATE.tar.gz"               # Backup file name

# Create a temporary backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Step 1: Compress the source directory into a tarball
echo "$DATE - Starting backup process..." >> $LOG_FILE
tar -czf $BACKUP_DIR/$BACKUP_NAME -C $SOURCE_DIR .

# Check if the compression was successful
if [ $? -eq 0 ]; then
    echo "$DATE - Backup successfully compressed: $BACKUP_NAME" >> $LOG_FILE
else
    echo "$DATE - Error: Backup compression failed" >> $LOG_FILE
    exit 1
fi

# Step 2: Copy the backup file to the destination EC2 instance using SCP
echo "$DATE - Copying backup to destination EC2 instance..." >> $LOG_FILE
scp -i $DESTINATION_KEY_PATH $BACKUP_DIR/$BACKUP_NAME $DESTINATION_USER@$DESTINATION_IP:$DESTINATION_DIR/

# Check if the copy was successful
if [ $? -eq 0 ]; then
    echo "$DATE - Backup successfully copied to destination EC2 instance" >> $LOG_FILE
else
    echo "$DATE - Error: Failed to copy backup to destination EC2 instance" >> $LOG_FILE
    exit 1
fi

# Step 3: Clean up the local backup file
rm -f $BACKUP_DIR/$BACKUP_NAME
echo "$DATE - Cleaned up local backup file: $BACKUP_NAME" >> $LOG_FILE

# Final message
echo "$DATE - Backup process completed successfully" >> $LOG_FILE
