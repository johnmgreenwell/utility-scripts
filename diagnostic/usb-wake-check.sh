#!/bin/bash
# Check which USB devices permit wake on activity
# Usage: usb-wake-check.sh

print "Checking USB devices for wakeup capability...\r\n"

for device in /sys/bus/usb/devices/*/power/wakeup; do
    if [[ -f "$device" ]]; then
        dev_path=$(dirname "$device")
        dev_name=$(basename "$dev_path")
        wake_setting=$(cat "$device")
        echo "Device: $dev_name - Wakeup: $wake_setting"
    fi
done


# EOF
