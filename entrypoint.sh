#!/bin/bash
set -e

# Source ROS2 and workspace
source /opt/ros/$ROS_DISTRO/setup.bash
#source /turtlebot3_ws/install/setup.bash

# Set environment variables
export TURTLEBOT3_MODEL=$TURTLEBOT3_MODEL
export ROS_DOMAIN_ID=$ROS_DOMAIN_ID

# Launch a shell (or you can auto‐launch bringup etc)
exec "$@"
