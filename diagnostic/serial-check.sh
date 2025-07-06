#!/bin/bash
# Scan for attached serial devices
# Usage: serial-check.sh

# Begin with the lsusb output, filtering root hubs
echo "Available USB devices:"
lsusb | grep -v -i "root hub"

echo ""

# List target serial devices in /dev
echo "Scanning for serial devices..."
devices=$(ls /dev/ttyUSB* /dev/ttyACM* /dev/ttyS* /dev/sda* 2>/dev/null)
if [[ -z "$devices" ]]; then
    echo "No serial devices found."
else
    echo "Found serial devices:"
    for dev in $devices; do
        echo $()"  $dev"
    done
fi

# List serial by id using readlink if available
if [ -d /dev/serial/by-id ]; then
    echo ""
    echo "Descriptive device names (from /dev/serial/by-id):"
    for link in /dev/serial/by-id/*; do
        [ -e "$link" ] && echo "  $link -> $(readlink -f "$link")"
    done
fi

echo ""

# List serial bus/device by /dev listing using vendor/model IDs
for dev in $devices; do
  if [ -e "$dev" ]; then
    udev_info=$(udevadm info --query=property --name="$dev")

    vendor_id=$(echo "$udev_info" | grep '^ID_USB_VENDOR_ID=' | cut -d'=' -f2)
    model_id=$(echo "$udev_info" | grep '^ID_USB_MODEL_ID=' | cut -d'=' -f2)

    if [ -z "$vendor_id" ] || [ -z "$model_id" ]; then
      echo "$dev: No USB vendor/product ID found"
      continue
    fi

    lsusb_info=$(lsusb | grep -i "$vendor_id:$model_id" | grep -v -i "root hub")

    if [ -n "$lsusb_info" ]; then
      echo "$dev: $lsusb_info"
    else
      echo "$dev: No matching lsusb entry for ID $vendor_id:$model_id"
    fi
  fi
done

# EOF
