#!/bin/zsh

pompom=$(curl -f http://localhost:6033/timer/remaining 2> /dev/null)

echo "$pompom"
