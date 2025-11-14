#!/bin/bash
# auto_connect_8bitdo.sh
# Automatically pairs and connects the 8BitDo controller over Bluetooth

DEVICE_MAC="D8:3A:DD:22:8C:65"

# Check if bluetoothctl is available
if ! command -v bluetoothctl &> /dev/null; then
    echo "bluetoothctl not found! Install bluez-utils first."
    exit 1
fi

echo "Checking if device $DEVICE_MAC is already paired..."

# Get paired devices
PAIRED=$(bluetoothctl paired-devices | grep "$DEVICE_MAC")

if [ -z "$PAIRED" ]; then
    echo "Device not paired. Pairing..."
    bluetoothctl << EOF
power on
agent on
default-agent
scan on
pair $DEVICE_MAC
trust $DEVICE_MAC
connect $DEVICE_MAC
exit
EOF
else
    echo "Device already paired. Connecting..."
    bluetoothctl << EOF
power on
connect $DEVICE_MAC
exit
EOF
fi

echo "Done."
