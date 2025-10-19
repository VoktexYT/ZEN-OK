#!/bin/bash

# Log tout dans un fichier
exec > /tmp/waybar_debug.log 2>&1

echo "=== Waybar Launch Debug ==="
echo "Date: $(date)"
echo "User: $USER"
echo "Display: $WAYLAND_DISPLAY"
echo "XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"

# Tue waybar
echo "Killing existing waybar..."
killall -q waybar

# Attends
sleep 1

# Vérifie que waybar existe
echo "Checking waybar binary..."
which waybar
waybar --version

# Lance waybar
echo "Starting waybar..."
waybar &

echo "Waybar PID: $!"
echo "=== End Debug ==="
