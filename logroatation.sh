#!/bin/bash

# Define log directory and retention period (7 days)
LOG_DIR="/var/log/myapp/"
RETENTION_DAYS=7
ARCHIVE_DIR="/backup/logs/"

# Create an archive of logs older than RETENTION_DAYS
find "$LOG_DIR" -type f -name "*.log" -mtime +$RETENTION_DAYS -exec tar -czf "$ARCHIVE_DIR/old_logs_$(date +%F).tar.gz" {} \;

# Remove old logs
find "$LOG_DIR" -type f -name "*.log" -mtime +$RETENTION_DAYS -exec rm -f {} \;

echo "Log rotation and cleanup completed."
