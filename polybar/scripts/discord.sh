#!/bin/zsh
state=$(curl -f http://localhost:7012 2> /dev/null)

if [[ $? -eq 0 ]]; then
    muted=$(echo $state | jq -r .muted)
    deaf=$(echo $state | jq -r .deaf)
    name=$(echo $state | jq -r .name)
fi

if [[ $deaf = "true" ]]; then
    echo "  $name"
elif [[ $muted = "true" ]]; then
    echo "  $name"
elif [[ $name != "" ]]; then
    echo "  $name"
else
    echo ""
fi
