#!/usr/bin/env bash

wifi=$(nmcli connection show --active | grep wifi)
ethernet=$(nmcli connection show --active | grep ethernet)

if [ -n "$wifi" ]; then
    echo "Connected to $( nmcli connection show --active | grep wif | hck -d '\s{2,}' -D \\n | head -n 1)"
    exit
elif [ -n "$ethernet" ]; then
    echo "Connected to $( nmcli connection show --active | grep ethernet | hck -d '\s{2,}' -D \\n | head -n 1)"
    exit
else
    echo "Not Connected"
    exit
fi
