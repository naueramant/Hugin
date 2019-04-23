# Tardis

## Features

TBA

## Getting started

1. Check that you have [compatible hardware](#hardware).
2. Download the [latest image](https://github.com/naueramant/tardis/releases).
3. Decompress it.
4. Flash the image onto your SD card. We recommend [Etcher](https://etcher.io/) for this: it's delightfully easy to use, cross platform, and will verify the result automatically. If you know what you're doing, you can of course also just `sudo dd bs=1m if=image.img of=/dev/mmcblk0`.
5. Insert the SD card to your Pi and power it up.
6. You should land in the [first-boot document](docs/first-boot.md), for further instructions & ideas.

## Hardware

Works with [Raspberry Pi versions 1, 2 & 3](https://www.raspberrypi.org/products/). The 3 series is recommended, as it's the most powerful, and comes with built-in WiFi (though both [official](https://www.raspberrypi.org/products/raspberry-pi-usb-wifi-dongle/) and [off-the-shelf](https://elinux.org/RPi_USB_Wi-Fi_Adapters) USB WiFi dongles can work equally well).

Make sure you have a [compatible 4+ GB SD card](http://elinux.org/RPi_SD_cards). In general, any Class 10 card will work, as they're fast enough and of high enough quality.

The Pi needs a [2.5 Amp power source](https://www.raspberrypi.org/documentation/hardware/raspberrypi/power/README.md). Most modern USB chargers you'll have laying around will work, but an older/cheaper one may not.

## Acknowledgements

This project is strongly inspired by [chilipie-kiosk](https://github.com/futurice/chilipie-kiosk).