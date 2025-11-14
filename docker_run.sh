docker run --rm -it \
  --name turtburg \
  --network host \
  --env ROS_DOMAIN_ID=30 \
  --env TURTLEBOT3_MODEL=burger \
  --privileged \
  --device /dev/ttyACM0:/dev/ttyACM0 \
  --device /dev/ttyUSB0:/dev/ttyUSB0 \
  --device /dev/input/js0:/dev/input/js0 \
  --volume /etc/udev/rules.d/:/etc/udev/rules.d/ \
  turtburg \
  bash
