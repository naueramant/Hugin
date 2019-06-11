#! /bin/bash

# Safeguard
if [ -z "$(command -v raspi-config)" ]; then
    echo "Script not running on raspbian, exiting..."
    exit -1
fi

# Add node 11 repo
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

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

# Quiet boot
echo "dwc_otg.lpm_enable=0 console=serial0,115200 console=tty3 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait quiet splash plymouth.ignore-serial-consoles logo.nologo vt.global_cursor_default=0" > /boot/cmdline.txt
echo -e "\ndisable_splash=1" >> /boot/config.txt

# Fix fstab
cat >/etc/fstab <<EOL
proc            /proc           proc    defaults          0       0
/dev/mmcblk0p1  /boot           vfat    defaults          0       2
/dev/mmcblk0p2  /               ext4    defaults,noatime  0       1
EOL

# Goodbye (delete this script)
rm -- "$0"
exit