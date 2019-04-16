#!/bin/bash

export DISPLAY=:0.0

# Start cursor at the top-left corner, as opposed to the default of dead-center
xdotool mousemove 0 0

# Set some useful X preferences
xset s off # don't activate screensaver
xset -dpms # disable DPMS (Energy Star) features.
xset s noblank # don't blank the video device

# Set X screen background
sudo nitrogen --set-centered background.png

# Hide cursor afer 5 seconds of inactivity
unclutter -idle 5 -root &

# Finally, switch process to our window manager
exec matchbox-window-manager -use_titlebar no