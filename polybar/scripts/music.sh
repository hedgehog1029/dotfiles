#!/bin/bash

status=$(playerctl status 2> /dev/null)

if [[ $? -eq 0 ]]; then
    metadata="$(playerctl metadata artist) - $(playerctl metadata title)"
fi

if [[ $status = "Playing" ]]; then
    echo "  $metadata"
elif [[ $status = "Paused" ]]; then
    echo "  $metadata"
else
    echo ""
fi
