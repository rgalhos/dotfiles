#!/bin/bash

if [[ "$(wpctl get-volume @DEFAULT_SINK@ | cut -d' ' -f2 | sed -E 's/0?\.//')" -lt "100" ]]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
fi

pw-cat --volume 2 -p /usr/share/sounds/ocean/stereo/audio-volume-change.oga
