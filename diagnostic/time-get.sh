#!/bin/bash
# Return a string of the current time UTC
# Usage: time-get.sh [short|full|iso|us|eu|epoch|human]

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
    us)
        date -u +"%m/%d/%Y %I:%M:%S %p"
        ;;
    eu)
        date -u +"%d/%m/%Y %H:%M:%S"
        ;;
    epoch)
        date -u +"%s"
        ;;
    human)
        date -u +"%I:%M %p on %m/%d/%Y"
        ;;
    *)
        echo "Usage: $0 [short|full|iso|us|eu|epoch|human]"
        exit 1
        ;;
esac

# EOF