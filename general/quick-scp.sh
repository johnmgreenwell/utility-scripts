#!/bin/bash
# Use scp to transfer input_file to destination_ip downloads folder
# Usage: ./script.sh input_file destination_ip

[ $# -ne 2 ] && { echo "Usage: $0 <input_file> <destination_ip>"; exit 1; }

INPUT_FILE="$1"
DEST_IP="$2"
DEST_USER="$USER"

scp "$INPUT_FILE" "${DEST_USER}@${DEST_IP}:~/Downloads/"

# EOF