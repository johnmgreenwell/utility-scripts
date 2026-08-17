#!/bin/bash
# List all active udev rules for external devices in the system
# Usage: ./udev-rules-list.sh

UDEV_RULES_DIRS=("/etc/udev/rules.d" "/lib/udev/rules.d" "/usr/lib/udev/rules.d")

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }

check_dir() {
    local dir=$1
    if [ -d "$dir" ]; then
        return 0
    else
        return 1
    fi
}

list_udev_rules() {
    echo "Listing udev rules related to external devices..."
    echo "-----------------------------------------------"

    for dir in "${UDEV_RULES_DIRS[@]}"; do
        if check_dir "$dir"; then
            echo "Checking directory: $dir"
            find "$dir" -type f -name "*.rules" | while IFS= read -r rule_file; do
                if grep -Ei 'SUBSYSTEM=="(usb|block|scsi|hid|input)"|KERNEL=="(sd[a-z]|hid|ttyUSB)"' "$rule_file" > /dev/null; then
                    echo "File: $rule_file"
                    echo "Contents:"
                    grep -Ei 'SUBSYSTEM=="(usb|block|scsi|hid|input)"|KERNEL=="(sd[a-z]|hid|ttyUSB)"' "$rule_file" | sed 's/^/  /'
                    echo "-----------------------------------------------"
                fi
            done
        else
            echo "Directory $dir does not exist or is not accessible."
        fi
    done
}

list_udev_rules
if [ -z "$(find "${UDEV_RULES_DIRS[@]}" -type f -name "*.rules" 2>/dev/null)" ]; then
    echo "No udev rules found in the specified directories."
fi

exit 0

# EOF
