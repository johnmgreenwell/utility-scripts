#!/bin/bash
# Check serial number of attached USB serial device
# Usage: usb-serial-num-check.sh [SERIAL_DEVICE]

SERIAL_DEVICE=$1

usage() {
  echo "Usage: $0 [SERIAL_DEVICE]"
  echo "Example: $0 /dev/ttyACM0"
  echo "If no device is specified, /dev/ttyACM0 is checked as a default."
}

if [ -z "$SERIAL_DEVICE" ]; then
  if [ -e "/dev/ttyACM0" ]; then
    SERIAL_DEVICE="/dev/ttyACM0"
  else
    echo "No USB serial device supplied, and /dev/ttyACM0 not attached."
    usage
    exit 1
  fi
fi

if [ ! -c "$SERIAL_DEVICE" ] || [ ! -r "$SERIAL_DEVICE" ]; then
  echo "Error with given serial device file."
  usage
  exit 2
fi

SERIAL_NUMBER=$(udevadm info --name=$SERIAL_DEVICE | grep SERIAL_SHORT | sed 's/.*SHORT=//')

if [ -z "$SERIAL_NUMBER" ]; then
  echo "Error: No serial number found for device '$SERIAL_DEVICE'."
  exit 3
fi

echo "$SERIAL_NUMBER"
exit 0

# EOF
