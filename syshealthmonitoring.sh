#!/bin/bash

# Set thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "CPU Usage is over threshold: $CPU_USAGE%" | mail -s "High CPU Usage Alert" admin@example.com
fi

# Check Memory usage
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
    echo "Memory Usage is over threshold: $MEMORY_USAGE%" | mail -s "High Memory Usage Alert" admin@example.com
fi

# Check Disk usage
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
    echo "Disk Usage is over threshold: $DISK_USAGE%" | mail -s "High Disk Usage Alert" admin@example.com
fi
