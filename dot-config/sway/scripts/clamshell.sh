#!/usr/bin/env bash

INTERNAL="eDP-1"
EXTERNAL="DP-1"

# Get lid state
LID=$(cat /proc/acpi/button/lid/*/state 2>/dev/null | awk '{print $2}')

# Check if external is active
EXTERNAL_ACTIVE=$(swaymsg -t get_outputs | jq -r '.[] | select(.name=="'"$EXTERNAL"'" and .active) | .name')

if [[ "$LID" == "closed" ]]; then
    if [[ -n "$EXTERNAL_ACTIVE" ]]; then
        # --- CLAMSHELL MODE ---
        swaymsg output "$INTERNAL" disable
        swaymsg output "$EXTERNAL" enable

        # Move all workspaces to external
        for ws in $(swaymsg -t get_workspaces | jq -r '.[].name'); do
            swaymsg workspace "$ws"
            swaymsg move workspace to output "$EXTERNAL"
        done

    else
        # --- NO EXTERNAL → SUSPEND ---
        systemctl suspend-then-hibernate
    fi
else
    # --- LID OPEN ---
    swaymsg output "$INTERNAL" enable
fi