#!/usr/bin/env bash
set -e

VPNPASSFILE=/etc/openvpn/domirete.pass

# Create vpnpass file
if [ -n "$USERNAME" ] && [ ! -z "$PASS" ]; then
    if [ -f "$VPNPASSFILE" ]; then
        echo "Using existing vpnpass file."
    else
        echo "Writing vpnpass file."
        echo "$USERNAME" > "$VPNPASSFILE"
        echo "$pass" >> "$VPNPASSFILE"
        chmod 600 "$VPNPASSFILE"
    fi
else
    echo "Username/password was not defined."
    exit 1
fi
