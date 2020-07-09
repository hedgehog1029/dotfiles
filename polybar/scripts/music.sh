#!/bin/bash

function spotifyctl() {
    playerctl -p spotify $@ 2> /dev/null
}

function audaciousctl() {
    playerctl -p audacious $@ 2> /dev/null
}

function autoctl() {
    playerctl -i chromium $@ 2> /dev/null
}

if [[ $(spotifyctl status) = "Playing" ]]; then
    metadata="$(spotifyctl metadata artist) - $(spotifyctl metadata title)"
    status="Playing"
elif [[ $(audaciousctl status) = "Playing" ]]; then
    metadata="$(audaciousctl metadata artist) - $(audaciousctl metadata title)"
    status="Playing"
elif [[ $(autoctl status) = "Paused" ]]; then
    metadata="$(autoctl metadata artist) - $(autoctl metadata title)"
    status="Paused"
else
    status="Stopped"
fi

if [[ $status = "Playing" ]]; then
    echo "  $metadata"
elif [[ $status = "Paused" ]]; then
    echo "  $metadata"
else
    echo ""
fi
