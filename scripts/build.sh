#! /bin/bash

SRC_IMG=$1
TARGET_IMG=$2
TMP_IMG=$TARGET_IMG.tmp

LOOP_DEV="/dev/loop2"
MNT_POINT="/mnt/pi"

# Check if inputs are given
if [ -z "$SRC_IMG" ]; then
    echo "No source .img file specified!"
    exit -1
fi

if [ ! -f "$SRC_IMG" ]; then
    echo "No such file $SRC_IMG"
    exit -1
fi

if [ -z "$TARGET_IMG" ]; then
    echo "No target .img file specificed"
    exit -1
fi

for CMD in qemu-arm-static parted resize2fs e2fsck
do
    if [ -z "$(command -v $CMD)" ]; then
        echo "Missing $CMD, please install"
        exit -1
    fi
done

# Check if qemu-arm-static is available
if [ -z "$(command -v qemu-arm-static)" ]; then
    echo "qemu-arm-static"
    exit -1
fi

function cleanup {
    sync
    sudo umount $MNT_POINT/boot > /dev/null 2>&1
    sudo umount $MNT_POINT > /dev/null 2>&1
    sudo losetup -d $LOOP_DEV > /dev/null 2>&1
    sudo rm $MNT_POINT -r > /dev/null 2>&1
}

function error {
    echo "An error occurred, exiting..."
    cleanup
    exit -1
}

# Error handling
trap "error" ERR

# Make tmp image
cp $SRC_IMG $TMP_IMG

# Increase tmp image size with 1G
sudo dd if=/dev/zero bs=300M count=1 >> $TMP_IMG
sudo parted $TMP_IMG resizepart 2 100%

sudo losetup --partscan $LOOP_DEV $TMP_IMG
sudo e2fsck -fy $LOOP_DEV"p2"
sudo resize2fs -f $LOOP_DEV"p2"

# Mount the image
sudo mkdir -p $MNT_POINT
sudo mount $LOOP_DEV"p2" $MNT_POINT
sudo mount $LOOP_DEV"p1" $MNT_POINT/boot

sleep 2

# Copy root dir into image
cp ./fs/* $MNT_POINT -r

# Inject build version
date +%Y-%m-%d > $MNT_POINT/home/pi/.version

# chroot into raspbian and run commands
sudo systemd-nspawn --bind /usr/bin/qemu-arm-static -qD $MNT_POINT /home/pi/setup.sh

# Clean up mounts
cleanup

# Move tmp image
mv $TMP_IMG $TARGET_IMG