#!/bin/bash
# Simple AVR flashing script
# Usage: avr-flash.sh [-b BIN_FILE] [-e EEP_FILE] [CHIP] <PROGRAMMER>
# BIN_FILE: .bin file to flash
# EEP_FILE: .eep file to flash
# CHIP: avrdude abbreviation for target microcontoller
# PROGRAMMER: avrdude abbreviation for programmer

# Default programmer
PROGRAMMER="atmelice"

help() {
  echo "Usage: $0 [-b BIN_FILE] [-e EEP_FILE] [-f FUSE_HEX] [CHIP] <PROGRAMMER>"
  echo "  -h            : This help info"
  echo "  -b BIN_FILE   : Flash .bin file"
  echo "  -e EEP_FILE   : Flash .eep file"
  echo "  -f FUSE_HEX   : Set low, high, extended fuses (e.g., FFDE05)"
  echo "         CHIP   : Chip name (avrdude)"
  echo "   PROGRAMMER   : Programmer (avrdude)"
}

FLASH_BIN=false
TARGET_BIN="none-provided"
FLASH_EEP=false
TARGET_EEP="none-provided"
FLASH_FUSES=false
FUSE_HEX="none-provided"

while getopts "hb:e:f:" opt; do
  case $opt in
    b)
      FLASH_BIN=true
      TARGET_BIN=$OPTARG
      ;;
    e)
      FLASH_EEP=true
      TARGET_EEP=$OPTARG
      ;;
    f)
      FLASH_FUSES=true
      FUSE_HEX=$OPTARG
      ;;
    h)
      help
      exit 0
      ;;
    *)
      help
      exit 1
      ;;
  esac
done

echo "Beginning operation..."

shift "$((OPTIND-1))"
[[ -z $1 ]] && { echo "No chip name provided. Exiting..."; exit 1; } || CHIP=$1
[[ -z $2 ]] && { echo "Default programmer: $PROGRAMMER" ; } || PROGRAMMER=$2

# Validate and parse fuses if provided
if $FLASH_FUSES; then
  if [[ ! $FUSE_HEX =~ ^[0-9A-Fa-f]{6}$ ]]; then
    echo "Error: FUSE_HEX must be a six-character hex string (e.g., FFDE05)"
    exit 1
  fi
  LFUSE=${FUSE_HEX:0:2}
  HFUSE=${FUSE_HEX:2:2}
  EFUSE=${FUSE_HEX:4:2}
fi

if $FLASH_BIN; then
  echo "Flashing $TARGET_BIN to $CHIP using $PROGRAMMER..."
  avrdude -p $CHIP -c $PROGRAMMER -U flash:w:$TARGET_BIN || { echo "Flash failed"; exit 1; }
fi
if $FLASH_EEP; then
  echo "Writing $TARGET_EEP to $CHIP using $PROGRAMMER..."
  avrdude -p $CHIP -c $PROGRAMMER -U eeprom:w:$TARGET_EEP || { echo "EEPROM write failed"; exit 1; }
fi
if $FLASH_FUSES; then
  echo "Setting fuses (low=0x$LFUSE, high=0x$HFUSE, extended=0x$EFUSE) for $CHIP using $PROGRAMMER..."
  avrdude -p $CHIP -c $PROGRAMMER -U lfuse:w:0x$LFUSE:m -U hfuse:w:0x$HFUSE:m -U efuse:w:0x$EFUSE:m || { echo "Fuse setting failed"; exit 1; }
fi

echo "Operation complete."
exit 0

# EOF
