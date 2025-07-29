#!/bin/bash
# Check serial number of attached USB serial device
# Usage: usb-serial-num-check.sh [SERIAL_DEVICE]

SERIAL_DEVICE=$1

if [ -z $SERIAL_DEVICE ]; then
  if [ -e "/dev/ttyACM0" ]; then
    SERIAL_DEVICE="/dev/ttyACM0"
  else
    echo "No USB serial device supplied, and /dev/ttyACM0 not attached."
    exit 1
  fi
fi

udevadm info --name=$DEV | grep SERIAL_SHORT | sed 's/.*SHORT=//'

exit 0

# EOF
