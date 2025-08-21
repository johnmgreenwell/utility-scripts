#!/bin/bash
# Check which USB devices permit wake on activity
# Usage: usb-wake-check.sh

printf "Checking USB devices for wakeup capability...\r\n"

for device in /sys/bus/usb/devices/*/power/wakeup; do
    if [[ -f "$device" ]]; then
        dev_path=$(dirname "$device")
        dev_name=$(basename "$dev_path")
        wake_setting=$(cat "$device")
        # Skip USB hubs (bDeviceClass == 09)
        [[ -f "$dev_path/bDeviceClass" ]] && [[ $(cat "$dev_path/bDeviceClass") == "09" ]] && continue
        product="Unknown"
        [[ -f "$dev_path/product" ]] && product=$(cat "$dev_path/product")
        echo "Device: $dev_name ($product) - Wakeup: $wake_setting"
    fi
done

printf "Operation completed.\r\n"

# EOF
