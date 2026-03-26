#!/usr/bin/env bash

# Watch for output changes (hotplug)
swaymsg -t subscribe "[\"output\"]" | while read -r _; do
    ~/.config/sway/scripts/clamshell.sh
done