#!/bin/bash
# Use scp to transfer input_file to destination_ip Downloads folder
# Usage: ./quick-scp.sh <input_file> <destination_ip> [destination_user]

[ $# -lt 2 ] && { echo "Usage: $0 <input_file> <destination_ip> [destination_user]"; exit 1; }
command -v scp >/dev/null 2>&1 || { echo "Command 'scp' not found."; exit 3; }

INPUT_FILE="$1"
DEST_IP="$2"
DEST_USER="${3:-$USER}"

# Validate inputs
[ ! -f "$INPUT_FILE" ] && { echo "Error: File '$INPUT_FILE' does not exist."; exit 2; }
if ! [[ "$DEST_IP" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ || "$DEST_IP" =~ ^[a-zA-Z0-9.-]+$ ]]; then
    echo "Error: '$DEST_IP' does not appear to be a valid IP address or hostname."
    exit 1
fi

# Proceed with transfer
if scp "$INPUT_FILE" "${DEST_USER}@${DEST_IP}:~/Downloads/" 2>/dev/null; then
    echo "File '$INPUT_FILE' successfully transferred to ${DEST_USER}@${DEST_IP}:~/Downloads/"
else
    echo "Error: Failed to transfer '$INPUT_FILE' to ${DEST_USER}@${DEST_IP}:~/Downloads/"
    exit 1
fi

exit 0

# EOF
