#!/bin/bash
# Return a string of the current time UTC
# Usage: time-get.sh [short|full|iso|epoch]

case "$1" in
    short)
        date -u +"%H:%M:%S"
        ;;
    full|"")
        date -u +"%Y-%m-%d %H:%M:%S UTC"
        ;;
    iso)
        date -u +"%Y-%m-%dT%H:%M:%SZ"
        ;;
    epoch)
        date -u +"%s"
        ;;
    *)
        echo "Usage: $0 [short|full|iso|epoch]"
        exit 1
        ;;
esac

# EOF