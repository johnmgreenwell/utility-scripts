#!/bin/bash
# Install batch list of programs using apt package manager
# Usage: batch-init.sh <APP_LIST_FILE>

APP_LIST="$1"

[ "$#" -eq 1 ] || { echo "Usage: $0 <APP_LIST_FILE>"; exit 1; }
[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 2; }
[[ ! -f "$APP_LIST" ]] && { echo "App list file \"$APP_LIST\" not found. Exiting..."; exit 3; }

echo "Updating apt package manager..."
apt-get update -qq || { echo "Failed to update apt. Exiting..."; exit 4; }

echo "Beginning batch application installation..."
command -v dpkg >/dev/null 2>&1 || { echo "Error: Command 'dpkg' not found."; exit 5; }

packages=()
while IFS= read -r line; do
  line=$(echo "$line" | tr -d '\r' | xargs)
  [[ -z "$line" || "$line" == \#* ]] && continue
  if [[ "$line" =~ ^[a-zA-Z0-9._+-]+$ ]]; then
    if ! dpkg -s "$line" >/dev/null 2>&1; then
      packages+=("$line")
    else
      echo "Application \"$line\" is already installed."
    fi
  else
    echo "Error: \"$line\" is not a single-word apt package name."
    exit 6
  fi
done < "$APP_LIST"

if [ ${#packages[@]} -gt 0 ]; then
  echo "Installing packages: ${packages[*]}"
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${packages[@]}" || { echo "Failed to install packages."; exit 7; }
fi

echo "Batch application installation complete."
exit 0

# EOF
