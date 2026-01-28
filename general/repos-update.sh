#!/bin/bash
# Recursively pull latest for all repos within cwd
# Usage: repos-update.sh

command -v find >/dev/null 2>&1 || { echo "Command 'find' not found."; exit 1; }

find . -type d -name .git -not -path '*/\.git/*' -prune | while read -r GITDIR; do
    repo=$(dirname "$GITDIR")
    echo "Pulling: $REPO"
    (cd "$REPO" && git pull --ff-only) && echo " ...success." || echo " ...failed."
done

echo "Repository pulls completed."
exit 0

# EOF
