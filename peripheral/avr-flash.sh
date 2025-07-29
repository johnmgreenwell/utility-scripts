#!/bin/bash
# Simple AVR flashing script
# Usage: avr-flash.sh [-b BIN_FILE] [-e EEP_FILE] [CHIP] <PROGRAMMER>
# BIN_FILE: .bin file to flash
# EEP_FILE: .eep file to flash
# CHIP: avrdude abbreviation for target microcontoller
# PROGRAMMER: avrdude abbreviation for programmer

help() {
  echo "Usage: $0 [-b BIN_FILE] [-e EEP_FILE] [CHIP] <PROGRAMMER>"
  echo "  -h          : This help info"
  echo "  -b BIN_FILE : Flash .bin file"
  echo "  -e EEP_FILE : Flash .eep file"
  echo "         CHIP : Chip name (avrdude)"
  echo "   PROGRAMMER : Programmer (avrdude)"
}

FLASH_BIN=false
TARGET_BIN="none-provided"
FLASH_EEP=false
TARGET_EEP="none-provided"

while getopts "hb:e:" opt; do
  case $opt in
    b)
      FLASH_BIN=true
      TARGET_BIN=$OPTARG
      ;;
    e)
      FLASH_EEP=true
      TARGET_EEP=$OPTARG
      ;;
    h)
      ;&
    *)
      help
      exit 1
      ;;
  esac
done

echo "Beginning operation..."

shift "$((OPTIND-1))"
[[ -z $1 ]] && { echo "No chip name provided. Exiting..."; exit 1; } || CHIP=$1
[[ -z $2 ]] && { echo "Default programmer: Atmel ICE" ; PROGRAMMER="atmelice"; } || PROGRAMMER=$2


if $FLASH_BIN ; then
  echo "Flashing $TARGET_BIN..."
  echo "avrdude -p $CHIP -c $PROGRAMMER -U flash:w:$TARGET_BIN"
fi
if $FLASH_EEP ; then
  echo "Flashing $TARGET_EEP..."
  echo "avrdude -p $CHIP -c $PROGRAMMER -U eeprom:w:$TARGET_EEP"
fi

echo "Operation complete. Fuses must be programmed separately."

exit 0

# EOF
