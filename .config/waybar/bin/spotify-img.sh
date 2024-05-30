#!/bin/bash

if [ "$(playerctl -p spotify status)" != "Playing" ]; then
    echo "invalid"
    exit 0
fi

echo "/tmp/cover"
