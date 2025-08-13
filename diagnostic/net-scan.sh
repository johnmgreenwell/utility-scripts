#!/bin/bash
# Scan for local machines on the given network (e.g. 192.168.1.0/24 by default)
# Usage: net-scan.sh [-v] [-n NETWORK] [-f TEXT|JSON]

# Defaults
NETWORK="192.168.1.0/24"
VERBOSE=0
OUTPUT_FORMAT="text"
LOGFILE="net-scan-$(date +%F_%H-%M-%S).log"

command -v ping >/dev/null 2>&1 || { echo "Error: ping is not installed."; exit 1; }
command -v nslookup >/dev/null 2>&1 || { echo "Error: nslookup is not installed."; exit 1; }

while getopts "vn:f:" opt; do
    case $opt in
        v) VERBOSE=1 ;;
        n) NETWORK="$OPTARG" ;;
        f) OUTPUT_FORMAT="$OPTARG" ;;
        *) echo "Usage: $0 [-v] [-n network] [-f text|json]"; exit 1 ;;
    esac
done

# Validation
if ! echo "$NETWORK" | grep -E '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}$' >/dev/null; then
    echo "Error: Invalid network range. Use CIDR notation (e.g., 192.168.1.0/24)."
    exit 1
fi

# Get hostname with fallback
get_hostname() {
    local ip=$1
    hostname=$(nslookup "$ip" 2>/dev/null | awk -F'= ' '/name/ {print $2}' | sed 's/\.$//')
    if [[ -z "$hostname" ]] && command -v host >/dev/null 2>&1; then
        hostname=$(host "$ip" 2>/dev/null | awk '/domain name/ {print $NF}' | sed 's/\.$//')
    fi
    echo "${hostname:-unknown}"
}

echo "Scanning network $NETWORK..." | tee -a "$LOGFILE"
echo "" | tee -a "$LOGFILE"

# Use arp-scan if available, otherwise fall back to ping
if command -v arp-scan >/dev/null 2>&1 && [[ $EUID -eq 0 ]]; then
    if [[ $VERBOSE -eq 1 ]]; then
        echo "Using arp-scan for detecting machines..." | tee -a "$LOGFILE"
    fi
    sudo arp-scan --localnet --quiet --ignoredups | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | while read -r ip mac _; do
        hostname=$(get_hostname "$ip")
        if [[ "$OUTPUT_FORMAT" == "json" ]]; then
            echo "{\"ip\": \"$ip\", \"hostname\": \"$hostname\", \"mac\": \"$mac\", \"status\": \"UP\", \"timestamp\": \"$(date -Iseconds)\"}" | tee -a "$LOGFILE"
        else
            echo "Host UP: $ip ($hostname) (MAC: $mac)" | tee -a "$LOGFILE"
        fi
    done
else
    echo "Utility arp-scan not installed or no root privileges, using ping..." | tee -a "$LOGFILE"
    export -f get_hostname
    seq -f "${NETWORK%.*}.%g" 1 254 | xargs -P 20 -I {} bash -c "
        if ping -c 1 -W 2 {} >/dev/null 2>&1 || ping -c 1 -W 2 {} >/dev/null 2>&1; then
            hostname=\$(get_hostname {})
            if [[ \"$OUTPUT_FORMAT\" == \"json\" ]]; then
                echo '{\"ip\": \"{}\", \"hostname\": \"$hostname\", \"status\": \"UP\", \"timestamp\": \"$(date -Iseconds)\"}' | tee -a \"$LOGFILE\"
            else
                echo 'Host UP: {} ($hostname)' | tee -a \"$LOGFILE\"
            fi
        fi
    "
fi

echo "" | tee -a "$LOGFILE"
echo "Scan complete at $(date)." | tee -a "$LOGFILE"
exit 0

# EOF
