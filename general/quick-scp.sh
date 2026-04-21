#!/bin/bash
# Use scp to transfer input_file(s) to destination_ip Downloads folder
# Usage: ./quick-scp.sh <input_file> <destination_ip> [destination_user]

[ $# -lt 2 ] && { echo "Usage: $0 <input_file> <destination_ip> [destination_user]"; exit 1; }
command -v scp >/dev/null 2>&1 || { echo "Error: Command 'scp' not found."; exit 2; }

INPUT_FILES=( "$(compgen -G "$1")" )
DEST_IP="$2"
DEST_USER="${3:-$USER}"

# Proceed with transfer
for file in "${INPUT_FILES[@]}"; do
    [ ! -d "$file" ] && [ ! -f "$file" ] && { echo "Error: File '$file' does not exist."; exit 4; }
    [ -d "$file" ] && SCP_FLAG="-rC" || SCP_FLAG="-C"
if scp "$SCP_FLAG" "$file" "${DEST_USER}@${DEST_IP}:~/Downloads/" 2>/dev/null; then
        echo "Target '$file' successfully transferred to ${DEST_USER}@${DEST_IP}:~/Downloads/"
    else
        echo "Error: Failed to transfer '$file' to ${DEST_USER}@${DEST_IP}:~/Downloads/"
        exit 1
    fi
done

exit 0

# EOF
