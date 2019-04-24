#! /bin/bash

BASE="http://director.downloads.raspberrypi.org/raspbian_lite/images"
RELEASE="$1"
FLAVOR="$2"
ZIP="$FLAVOR.zip"
IMAGE="$FLAVOR.img"

if [ -f "$3/$IMAGE" ]; then
    echo "Skipping download"
    exit
fi

echo "Downloading $ZIP"
curl -o "$3/$ZIP" "$BASE/$RELEASE/$ZIP"

echo "Extracting $ZIP"
unzip -f "$3/$ZIP" -d "$3"
rm "$3/$ZIP"