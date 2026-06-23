#!/bin/bash
# Install batch list of programs using apt package manager
# Usage: batch-init.sh <APP_LIST_FILE>

APP_LIST=$1

[ $(id -u) -ne 0 ] && { echo "This script requires admin privileges."; exit 1; }
[ "$#" -eq 1 ] || { echo "Usage: $0 [APP_LIST_FILE]"; exit 2; }
[[ ! -f "$APP_LIST" ]] && { echo "App list file \"$APP_LIST\" not found. Exiting..."; exit 3; }

echo "Updating apt..."
sudo apt update || { echo "Failed to update apt. Exiting..."; exit 4; }

echo "Beginning batch application installation..."
while IFS= read -r line; do
  line=$(echo "$line" | tr -d '\r' | xargs)
  [[ -z "$line" ]] && continue
  if [[ "$line" =~ ^[a-zA-Z0-9]+$ ]]; then
    if which "$line" >/dev/null 2>&1; then
      echo "Application \"$line\" is already installed."
    else
      echo "Installing \"$line\"."
      sudo apt install "$line" -y || { echo "Failed to install \"$line\"."; exit 5; }
      echo "Installed \"$line\"."
    fi
  else
    echo "Error: \"$line\" is not a single-word apt package name."
	exit 6
  fi
done < "$APP_LIST"

echo "Batch application installation complete."

exit 0

# EOF
