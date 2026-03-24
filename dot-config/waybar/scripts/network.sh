#!/bin/bash
# Toggle the network menu for nm-applet

# Check if nm-applet is running
if ! pgrep -x nm-applet >/dev/null; then
    nm-applet & disown
    sleep 1
fi

# Use dbus to open the menu
dbus-send --session --dest=org.freedesktop.NetworkManager.Applet \
          --type=method_call \
          /org/freedesktop/NetworkManager/Applet \
          org.freedesktop.NetworkManager.Applet.ActivateMenu