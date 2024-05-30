#!/bin/bash

if [ "$(playerctl -p spotify status)" != "Playing" ]; then
    exit 0
fi

now_playing=$(playerctl -p spotify metadata --format "{{ artist }} - {{ title }}")

position=$(playerctl -p spotify position)
duration=$(bc <<< "$(playerctl -p spotify metadata mpris:length)/1000000")
maxsize=$(bc <<< "${#now_playing} * 8")
maxsize=$(( maxsize > 800 ? 800 : maxsize ))
elapsed=$(bc <<< "$position * $maxsize / $duration")
elapsed=$(( elapsed > 800 ? 800 : elapsed ))

progress="<span font='1px' line-height='1px' background='#1db954'>$(printf ' %.0s' $(seq 1 "$elapsed"))</span><span background='#ffffff' font='1px'>$(printf ' %.0s' $(seq 1 "$(( maxsize - elapsed ))"))</span>"
now_playing=$(playerctl -p spotify metadata --format "$now_playing\n$progress")

cover=$(playerctl -p spotify metadata mpris:artUrl)
filename="${cover#*image/}"
filepath="/tmp/$filename"

if [ -n "$cover" ] && [ ! -e "$filepath" ]; then
    curl -s "$cover" --output "$filepath"
    unlink /tmp/cover
    ln -s "$filepath" /tmp/cover
elif [ "$(readlink -f /tmp/cover)" != "$filepath" ]; then
    unlink /tmp/cover
    ln -s "$filepath" /tmp/cover
fi
    
echo '{"text": "'"$now_playing"'", "class": "custom-spotify", "alt": "Spotify"}'
