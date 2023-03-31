#!/bin/bash

RELEASES=$(curl -s "https://api.github.com/repos/nwjs-ffmpeg-prebuilt/nwjs-ffmpeg-prebuilt/releases/latest")

DOWNLOAD_URL=$(echo $RELEASES | ~/.scripts/getj.js "assets.find(x => x.name.includes('linux-x64')).browser_download_url" --unsafe)

curl -L "$DOWNLOAD_URL" -o /tmp/opera-ffmpeg.zip && \
unzip /tmp/opera-ffmpeg.zip -d /tmp && \

sudo rm /usr/lib/x86_64-linux-gnu/opera/libffmpeg.so && \
sudo mv /tmp/libffmpeg.so /usr/lib/x86_64-linux-gnu/opera/ && \
echo "Done!"
