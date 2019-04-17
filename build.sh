#! /bin/bash

SRC_IMG=$1
TARGET_IMG=$2
TMP_IMG=$TARGET_IMG.tmp

SECTOR_SIZE=512
LOOP_DEV="/dev/loop2"
TMP_IMG_SIZE="4G"
IMG_SPARE_SPACE="200M"
MNT_POINT=/mnt/pi

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

# Check if qemu-arm-static is available
if [ -z "$(command -v qemu-arm-static)" ]; then
    echo "qemu-arm-static binary not found!"
    exit -1
fi

# Error handling

function clean {
    sudo losetup -d $LOOP_DEV > /dev/null 2>&1
    
    sudo rm $MNT_POINT/usr/bin/qemu-arm-static > /dev/null 2>&1
    sudo umount $MNT_POINT > /dev/null 2>&1
    sync
    sudo rm $MNT_POINT -r > /dev/null 2>&1

    exit -1
}

trap "clean" ERR

# Find root sector start
SECTOR_START=$(($(fdisk -l $SRC_IMG | grep "^$SRC_IMG" | tail -n +2 | awk -F" "  '{ print $2 }') * $SECTOR_SIZE))

# Make tmp image
cp $SRC_IMG $TMP_IMG

# Increase tmp image size
ORIG_SIZE=$(du -h $TMP_IMG | awk -F" " '{print $1}')
DIFF_SIZE=$[$(numfmt --from=iec $TMP_IMG_SIZE) - $(numfmt --from=iec $ORIG_SIZE)]

dd if=/dev/zero bs=1 count=1 seek=$DIFF_SIZE of=$TMP_IMG
parted $TMP_IMG resizepart 2 100%

sudo losetup --offset=$SECTOR_START $LOOP_DEV $TMP_IMG
sudo e2fsck -f $LOOP_DEV
sudo resize2fs -f $LOOP_DEV
sudo losetup -d $LOOP_DEV

# Mount the image
sudo mkdir -p $MNT_POINT
sudo mount -o loop,offset=$SECTOR_START $TMP_IMG $MNT_POINT

# Copy root dir into image
cp ./root/* $MNT_POINT -r

# Copy qemu-arm-static binary
sudo cp $(which qemu-arm-static) $MNT_POINT/usr/bin

# chroot into raspbian and run commands
sudo systemd-nspawn -D $MNT_POINT /bin/bash << EOF
# Add node 11 repo
curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -

# Install dependencies
apt update
apt install -y vim matchbox-window-manager unclutter nitrogen chromium-browser xserver-xorg xinit rpd-plym-splash xdotool nodejs
apt clean

# Set plymouth splash screen
rm /usr/share/plymouth/themes/pix/splash.png
ln -s /home/pi/background.png /usr/share/plymouth/themes/pix/splash.png

# Set auto login for tty1-3
sed /etc/systemd/system/autologin@.service -i -e "s#^ExecStart=-/sbin/agetty --autologin [^[:space:]]*#ExecStart=-/sbin/agetty --autologin pi#"
ln -fs /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
ln -fs /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty2.service
ln -fs /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty3.service

systemctl set-default multi-user.target

# Enable ssh
systemctl enable ssh

# Quiet motd
rm /etc/profile.d/sshpwd.sh
echo | sudo tee /etc/motd

# Set hostname
hostnamectl set-hostname pup
sed -i 's/raspberrypi/pup/g' /etc/hosts

# Goodbye
exit
EOF

# Clean up
sudo rm $MNT_POINT/usr/bin/qemu-arm-static
sudo umount $MNT_POINT
sync
sudo rm $MNT_POINT -r

# Shrink image
SECTOR_END=$(($(($(fdisk -l $TMP_IMG | grep "^$TMP_IMG" | tail -n +2 | awk -F" "  '{ print $3 }') + 1)) * $SECTOR_SIZE))
truncate --size=$SECTOR_END $TMP_IMG

# Move tmp image
mv $TMP_IMG $TARGET_IMG