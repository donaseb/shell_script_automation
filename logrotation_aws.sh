#!/bin/bash

# Define log directory and retention period (7 days)
LOG_DIR="/var/log/myapp/"
RETENTION_DAYS=7
S3_BUCKET="s3://my-log-backups"  # Replace with your S3 bucket name

# Create a timestamp for the backup file
DATE=$(date +%F)
ARCHIVE_NAME="old_logs_$DATE.tar.gz"

# Find and create an archive of logs older than RETENTION_DAYS
echo "Creating archive of logs older than $RETENTION_DAYS days..."
find "$LOG_DIR" -type f -name "*.log" -mtime +$RETENTION_DAYS -exec tar -czf "/tmp/$ARCHIVE_NAME" {} \;

# Check if the tar command was successful
if [ $? -eq 0 ]; then
    echo "Log archive created successfully: /tmp/$ARCHIVE_NAME"
else
    echo "Error creating log archive."
    exit 1
fi

# Upload the archive to S3
echo "Uploading archive to S3..."
aws s3 cp "/tmp/$ARCHIVE_NAME" "$S3_BUCKET/$ARCHIVE_NAME"

# Check if the upload was successful
if [ $? -eq 0 ]; then
    echo "Log archive uploaded to S3: $S3_BUCKET/$ARCHIVE_NAME"
else
    echo "Error uploading log archive to S3."
    exit 1
fi

# Remove old logs from local directory
echo "Removing old logs from local directory..."
find "$LOG_DIR" -type f -name "*.log" -mtime +$RETENTION_DAYS -exec rm -f {} \;

# Check if the removal was successful
if [ $? -eq 0 ]; then
    echo "Old logs removed from $LOG_DIR."
else
    echo "Error removing old logs."
    exit 1
fi

# Clean up the local archive
rm -f "/tmp/$ARCHIVE_NAME"

# Final message
echo "Log rotation and cleanup completed successfully."
