#!/bin/bash
# Create a new udev rule for a particular peripheral attachment by name
# Requires bus and device numbers (e.g. via lsusb) of intended peripheral,
# as well as the intended udev enforced name (e.g. 'cam_1' etc.)
# Usage: ./create-udev-rule.sh <BUS_NUM> <DEVICE_NUM> <DEVICE_NAME>

RULE_FILE="/etc/udev/rules.d/99-custom.rules"

if [ "$EUID" -ne 0 ]; then
    echo "This script requires root privileges to access some udev rules."
    echo "Please run with sudo or as root."
    exit 1
fi

[ "$#" -eq 3 ] || { echo "Usage: $0 <BUS_NUM> <DEVICE_NUM> <DEVICE_NAME>"; exit 1; }

BUS_NUM=$1
DEVICE_NUM=$2
DEVICE_NAME=$3

DEVICE_PATH=$(lsusb -s "$BUS_NUM:$DEVICE_NUM" | awk '{print $6}')
[ -z "$DEVICE_PATH" ] && { echo "Device $BUS_NUM:$DEVICE_NUM not found."; exit 1; }

SYSFS_PATH=$(find /sys/bus/usb/devices/usb*/ -name "*$DEVICE_PATH")
[ -z "$SYSFS_PATH" ] && { echo "Could not locate sysfs path for device $DEVICE_PATH."; exit 1; }

ID_VENDOR=$(udevadm info -a -p "$SYSFS_PATH" | grep -m1 "ATTRS{idVendor}" | awk -F'==' '{print $2}' | tr -d '" ')
ID_PRODUCT=$(udevadm info -a -p "$SYSFS_PATH" | grep -m1 "ATTRS{idProduct}" | awk -F'==' '{print $2}' | tr -d '" ')
SERIAL=$(udevadm info -a -p "$SYSFS_PATH" | grep -m1 "ATTRS{serial}" | awk -F'==' '{print $2}' | tr -d '" ')

echo "Using $RULE_FILE..."
echo "Creating udev rule..."
echo "SUBSYSTEM==\"usb\", ATTR{idVendor}==\"$ID_VENDOR\", ATTR{idProduct}==\"$ID_PRODUCT\", ATTR{serial}==\"$SERIAL\", SYMLINK+=\"${DEVICE_NAME}\"" | sudo tee -a "$RULE_FILE" > /dev/null
echo "Reloading udev rules..."
sudo udevadm control --reload-rules
sudo udevadm trigger
echo "Udev rule added. Device accessible at /dev/$DEVICE_NAME."

[ -e "/dev/$DEVICE_NAME" ] && echo "/dev/$DEVICE_NAME successfully created!" || echo "/dev/$DEVICE_NAME not yet created. Please check device and try again."

# EOF