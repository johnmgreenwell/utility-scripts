#!/bin/bash
# Unmute audio volume
# Usage: volume-on.sh

amixer -D pulse sset Master unmute

# EOF
