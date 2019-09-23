#!/bin/sh

cat <<EOF
# OS detection
nmap -A <host>

# Scan 100 most common ports
nmap -F <host>

# Ignore/skip host discovery
-Pn
EOF
