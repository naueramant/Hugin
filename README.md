
<div style="text-align: center;">
    <img src="doc/black_logo.png" height=200>
</div>

## Screenshots

TBA

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

## Development

TBA

## Common issues

- **I get a kernel panic on boot, or the image keeps crashing.** The Raspberry Pi is somewhat picky about about its SD cards. It's also possible the SD card has a bad sector in a critical place, and `dd` wasn't be able to tell you. Double-check that you're using [a blessed SD card](http://elinux.org/RPi_SD_cards), and try flashing the image again.
- **I see a "rainbow square" or "yellow lightning" in the top right corner of the screen, and the device seems unstable.** This usually means the Pi isn't getting enough amps from your power supply. This is sometimes the case in more exotic setups (e.g. using the USB port of your display to power the Pi) or with cheap power supplies. Try another one.

## Acknowledgements

This project is strongly inspired by [chilipie-kiosk](https://github.com/futurice/chilipie-kiosk).