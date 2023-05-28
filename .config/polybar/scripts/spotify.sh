#!/bin/bash

{
    INFO=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata)
    STATUS=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | grep string | cut -d'"' -f2)

    if [ "$STATUS" = "Playing" ]; then
        echo -n $'󰎈 '
    else
        #echo -n $'󰏤 '
        echo ''
        exit
    fi
    
    echo -n "$(echo "$INFO" | sed -n '/title/{n;p}' | cut -d '"' -f2)"
    echo -n '  •  '
    echo -n "$(echo -n "$INFO" | sed -n '/artist/{n;n;p}' | cut -d'"' -f2)"
}
