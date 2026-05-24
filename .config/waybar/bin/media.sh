#!/bin/bash

spotify() {
    now_playing=$("$HOME/.config/waybar/bin/spotify-lyrics.sh")
    if [ ! -n "${now_playing// /}" ]; then
        now_playing=$(playerctl -p spotify metadata --format "{{ artist }} - {{ title }}")
    fi

    position=$(playerctl -p spotify position)
    duration=$(( "$(playerctl -p spotify metadata mpris:length)" / 1000000 ))
    maxsize=$(( "$(wc -L <<< "$now_playing")" * 8 ))
    maxsize=$(( maxsize > 800 ? 800 : maxsize ))
    elapsed=$(bc <<< "$position * $maxsize / $duration")
    elapsed=$(( elapsed > 800 ? 800 : elapsed ))

    progress="<span font='1px' line-height='1px' background='#1db954'>$(printf ' %.0s' $(seq 1 "$elapsed"))</span><span background='#ffffff' font='1px'>$(printf ' %.0s' $(seq 1 "$(( maxsize - elapsed ))"))</span>"
    now_playing="$(echo "$now_playing" | sed -e 's/&/&amp;/g' -e 's/</&lt;/g')"
    now_playing="$now_playing\n$progress"

    cover=$(playerctl -p spotify metadata mpris:artUrl)
    filepath="/tmp/${cover#*image/}"

    if [ -n "$cover" ] && [ ! -e "$filepath" ]; then
        curl -s "$cover" --output "$filepath"
        unlink /tmp/cover
        ln -s "$filepath" /tmp/cover
    elif [ "$(readlink -f /tmp/cover)" != "$filepath" ]; then
        unlink /tmp/cover
        ln -s "$filepath" /tmp/cover
    fi
    
    echo '{"text": "'"$now_playing"'", "class": "custom-spotify", "alt": "Spotify"}'
}

youtube() {
    now_playing="$(playerctl metadata --format "{{ artist }} - {{ title }}")"
    now_playing="$(echo "$now_playing" | sed -e 's/&/&amp;/g' -e 's/</&lt;/g')"

    position=$(playerctl position)
    duration=$(( "$(playerctl metadata mpris:length)" / 1000000 ))
    maxsize=$(( "$(wc -L <<< "$now_playing")" * 8 ))
    maxsize=$(( maxsize > 800 ? 800 : maxsize ))
    elapsed=$(bc <<< "$position * $maxsize / $duration")
    elapsed=$(( elapsed > 800 ? 800 : elapsed ))

    progress="<span font='1px' line-height='1px' background='#ff0000'>$(printf ' %.0s' $(seq 1 "$elapsed"))</span><span background='#ffffff' font='1px'>$(printf ' %.0s' $(seq 1 "$(( maxsize - elapsed ))"))</span>"
    now_playing="$now_playing\n$progress"

    cover="$(playerctl metadata mpris:artUrl)"

    if [[ "$cover" =~ file* ]]; then
        cover="${cover#file://}"

        if [ "$(readlink -f /tmp/cover)" != "$cover" ]; then
            unlink /tmp/cover
            ln -s "$cover" /tmp/cover
        fi
    fi

    echo '{"text": "'"$now_playing"'", "class": "custom-spotify", "alt": "Spotify"}'
}

if [ "$(playerctl -p spotify status)" = 'Playing' ]; then
    spotify
elif playerctl metadata xesam:url | grep -q youtube; then
    youtube
fi
