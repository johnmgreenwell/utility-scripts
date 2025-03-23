#!/bin/bash
# Check if a service is active and restart it if it is not
# Usage: task-check.sh <SERVICE_NAME>

if [ -z "$1" ]; then
    echo "Usage: $0 <NAME_OF_SERVICE_TO_BE_CHECKED>"
    exit 1
fi

SERVICE="$1"

if ! systemctl is-active --quiet "$SERVICE"; then
    echo "$(date): $SERVICE is not running. Restarting..." >> /var/log/service_monitor.log
    systemctl restart "$SERVICE"
	
    if systemctl is-active --quiet "$SERVICE"; then
        echo "$(date): Successfully restarted $SERVICE" >> /var/log/service_monitor.log
    else
        echo "$(date): Failed to restart $SERVICE" >> /var/log/service_monitor.log
    fi
else
    echo "$(date): $SERVICE is running." >> /var/log/service_monitor.log
fi

# EOF