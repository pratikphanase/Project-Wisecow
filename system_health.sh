#!/bin/bash

# Log file path
LOG_FILE="/var/log/system_health.log"

# Create the log file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    sudo touch "$LOG_FILE"
    sudo chmod 666 "$LOG_FILE"
fi

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

# Get the current CPU, memory, and disk usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
DISK_USAGE=$(df -h / | grep / | awk '{ print $5 }' | sed 's/%//g')

# Date and time
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Logging function
log_message() {
    echo "$DATE - $1" | tee -a "$LOG_FILE"
}

# Check CPU usage
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    log_message "ALERT: High CPU usage detected: ${CPU_USAGE}%"
fi

# Check memory usage
if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
    log_message "ALERT: High memory usage detected: ${MEM_USAGE}%"
fi

# Check disk usage
if (( DISK_USAGE > DISK_THRESHOLD )); then
    log_message "ALERT: High disk usage detected: ${DISK_USAGE}%"
fi

# Log normal status if no issues
if (( $(echo "$CPU_USAGE <= $CPU_THRESHOLD" | bc -l) && $(echo "$MEM_USAGE <= $MEM_THRESHOLD" | bc -l) && DISK_USAGE <= $DISK_THRESHOLD )); then
    log_message "System health is normal: CPU=${CPU_USAGE}%, Memory=${MEM_USAGE}%, Disk=${DISK_USAGE}%"
fi
