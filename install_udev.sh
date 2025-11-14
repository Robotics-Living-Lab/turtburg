#!/usr/bin/env bash
set -e

RULES_DIR="/etc/udev/rules.d"

echo "[+] Installing TurtleBot3 and LD08 udev rules"

# OpenCR CDC rules
curl -sSL https://raw.githubusercontent.com/ROBOTIS-GIT/OpenCR/master/99-opencr-cdc.rules \
  -o /tmp/99-opencr-cdc.rules
sudo cp /tmp/99-opencr-cdc.rules "$RULES_DIR/99-opencr-cdc.rules"

curl -sSL https://raw.githubusercontent.com/ROBOTIS-GIT/turtlebot3/refs/heads/main/turtlebot3_bringup/script/99-turtlebot3-cdc.rules \
  -o /tmp/99-turtlebot3-cdc.rules
sudo cp /tmp/99-turtlebot3-cdc.rules "$RULES_DIR/99-turtlebot3-cdc.rules"

sudo udevadm control --reload-rules
sudo udevadm trigger

echo "[+] Done"
