#! /bin/bash

BUILD_DIR=$1
RELEASE_DIR=$2
NAME=$3

echo "Copy image"
cp "$BUILD_DIR/$NAME.img" "$RELEASE_DIR"

echo "Making md5sum..."
md5sum "$RELEASE_DIR/$NAME.img" > "$RELEASE_DIR/$NAME.img.md5"

echo "Zipping..."
zip "$RELEASE_DIR/$NAME.zip" "$RELEASE_DIR/$NAME.img" "$RELEASE_DIR/$NAME.img.md5"

echo "Cleaning"
rm "$RELEASE_DIR/$NAME.img" "$RELEASE_DIR/$NAME.img.md5"