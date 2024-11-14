#!/bin/bash

# Set thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Define SNS Topic ARN (replace with your SNS topic ARN)
SNS_TOPIC_ARN="arn:aws:sns:us-east-1:123456789012:HighUsageAlertTopic"

# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    ALERT_MESSAGE="CPU Usage is over threshold: $CPU_USAGE%"
    echo "$ALERT_MESSAGE"
    aws sns publish --topic-arn "$SNS_TOPIC_ARN" --message "$ALERT_MESSAGE" --subject "High CPU Usage Alert"
fi

# Check Memory usage
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
    ALERT_MESSAGE="Memory Usage is over threshold: $MEMORY_USAGE%"
    echo "$ALERT_MESSAGE"
    aws sns publish --topic-arn "$SNS_TOPIC_ARN" --message "$ALERT_MESSAGE" --subject "High Memory Usage Alert"
fi

# Check Disk usage
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
    ALERT_MESSAGE="Disk Usage is over threshold: $DISK_USAGE%"
    echo "$ALERT_MESSAGE"
    aws sns publish --topic-arn "$SNS_TOPIC_ARN" --message "$ALERT_MESSAGE" --subject "High Disk Usage Alert"
fi
