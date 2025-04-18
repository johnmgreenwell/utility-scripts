#!/bin/bash
# Mute audio volume
# Usage: volume-off.sh

amixer -D pulse sset Master mute

# EOF
