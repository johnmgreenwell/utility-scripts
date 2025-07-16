#!/bin/bash
# Check if a service is active and restart it if it is not
# Given no arguments, will list all active systemd services that are running
# Usage: task-check.sh <SERVICE_NAME>

if [ "$EUID" -ne 0 ]; then
    echo "This script requires root privileges."
    echo "Please run with sudo or as root."
    exit 1
fi

type systemctl &> /dev/null || { echo "Error: systemctl not found. This script requires systemd."; exit 1; }

if [ -z "$1" ]; then
    total=$(sudo systemctl list-units --type=service --state=running --no-pager | grep -c '.service')
    echo "Currently active and running systemd services:"
    echo "----------------------------------------"
    sudo systemctl list-units --type=service --state=running --no-pager | awk '{print $1, $4}' | column -t
    echo -e "\nTotal running services: $total"
    exit 0
fi

SERVICE="$1"

if ! sudo systemctl is-active --quiet "$SERVICE"; then
    echo "$(date): $SERVICE is not running. Restarting..." | sudo tee -a "/var/log/service_monitor.log"
    sudo systemctl restart "$SERVICE"

    if sudo systemctl is-active --quiet "$SERVICE"; then
        echo "$(date): Successfully restarted $SERVICE" | sudo tee -a "/var/log/service_monitor.log"
    else
        echo "$(date): Failed to restart $SERVICE" | sudo tee -a "/var/log/service_monitor.log"
    fi
else
    echo "$(date): $SERVICE is running." | sudo tee -a "/var/log/service_monitor.log"
fi

# EOF
