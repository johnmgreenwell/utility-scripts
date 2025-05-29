#!/bin/bash
# Create a new udev rule for a particular peripheral attachment by name
# Usage: ./create-udev-rule.sh <BUS_NUM> <DEVICE_NUM> <DEVICE_NAME>

[ "$#" -eq 3 ] || { echo "Usage: $0 <BUS_NUM> <DEVICE_NUM> <DEVICE_NAME>"; exit 1; }

BUS_NUM=$1
DEVICE_NUM=$2
DEVICE_NAME=$3

DEVICE_PATH=$(lsusb -s "$BUS_NUM:$DEVICE_NUM" | awk '{print $6}')
if [ -z "$DEVICE_PATH" ]; then
    echo "Device not found."
    exit 1
fi

SYSFS_PATH=$(find /sys/bus/usb/devices/usb*/ -name "*$DEVICE_PATH")
if [ -z "$SYSFS_PATH" ]; then
    echo "Could not locate sysfs path for device."
    exit 1
fi

ID_VENDOR=$(udevadm info -a -p "$SYSFS_PATH" | grep -m1 "ATTRS{idVendor}" | awk -F'==' '{print $2}' | tr -d '" ')
ID_PRODUCT=$(udevadm info -a -p "$SYSFS_PATH" | grep -m1 "ATTRS{idProduct}" | awk -F'==' '{print $2}' | tr -d '" ')
SERIAL=$(udevadm info -a -p "$SYSFS_PATH" | grep -m1 "ATTRS{serial}" | awk -F'==' '{print $2}' | tr -d '" ')

RULE_FILE="/etc/udev/rules.d/99-custom.rules"
echo "Creating udev rule..."
echo "SUBSYSTEM==\"usb\", ATTR{idVendor}==\"$ID_VENDOR\", ATTR{idProduct}==\"$ID_PRODUCT\", ATTR{serial}==\"$SERIAL\", SYMLINK+=\"${DEVICE_NAME}\"" | sudo tee -a "$RULE_FILE" > /dev/null
echo "Reloading udev rules..."
sudo udevadm control --reload-rules
sudo udevadm trigger
echo "Udev rule added. Your device should now be accessible at /dev/$DEVICE_NAME (if permissions allow)."

if [ -e "/dev/$DEVICE_NAME" ]; then
    echo "/dev/$DEVICE_NAME successfully created!"
else
    echo "/dev/$DEVICE_NAME not yet created. Try unplugging and replugging the device."
fi

# EOF