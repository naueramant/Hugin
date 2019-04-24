#! /bin/bash

BUILD_DIR=$1
RELEASE_DIR=$2
NAME=$3

if [ ! -f "$BUILD_DIR/$NAME.img" ]; then
    echo "No current build to release, please run: make build"
    exit -1
fi

echo "Copy image"
cp "$BUILD_DIR/$NAME.img" "$RELEASE_DIR"

cd $RELEASE_DIR

echo "Making md5sum..."
md5sum "$NAME.img" > "$NAME.img.md5"

echo "Zipping..."
zip "$NAME.zip" "$NAME.img" "$NAME.img.md5"

echo "Cleaning"
rm "$NAME.img" "$NAME.img.md5"