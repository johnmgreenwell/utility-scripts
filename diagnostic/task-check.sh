#!/bin/bash
# Check if a service is active and restart it if it is not
# Given no arguments, will list all active systemd services that are running
# Usage: task-check.sh <SERVICE_NAME>

[ command -v systemctl &> /dev/null ] || { echo "Error: systemctl not found. This script requires systemd."; exit 1; }

if [ -z "$1" ]; then
    echo "Usage: $0 <NAME_OF_SERVICE_TO_BE_CHECKED>"
    echo "Currently active running systemd services:"
    echo "----------------------------------------"
    systemctl list-units --type=service --state=running --no-pager | awk '{print $1, $4}' | column -t
    total=$(systemctl list-units --type=service --state=running --no-pager | grep -c '.service')
    echo -e "\nTotal running services: $total"
    exit 0
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