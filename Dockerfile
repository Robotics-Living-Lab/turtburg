# Use an ARM‐64 Ubuntu image (since RPi4 + Ubuntu 22.04 64-bit)
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    ROS_DISTRO=humble \
    ROS_DOMAIN_ID=30 \
    TURTLEBOT3_MODEL=burger

# Install basic required packages
RUN apt-get update && apt-get install -y \
    locales \
    sudo \
    curl \
    gnupg2 \
    lsb-release \
    git \
    build-essential \
    python3-pip \
    python3-argcomplete \
    libboost-system-dev \
    libudev-dev \
    udev \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Set locale
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Install colcon
RUN pip3 install -U colcon-common-extensions


# Setup ROS2 repositories
RUN curl -sSL http://repo.ros2.org/repos.key | apt-key add - && \
    echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list

# Install ROS2 base
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-ros-base \
    && rm -rf /var/lib/apt/lists/*

# Install TurtleBot3 dependencies
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-hls-lfcd-lds-driver \
    ros-${ROS_DISTRO}-turtlebot3-msgs \
    ros-${ROS_DISTRO}-dynamixel-sdk \
    ros-${ROS_DISTRO}-xacro \
    && rm -rf /var/lib/apt/lists/*

# Setup workspace
RUN mkdir -p /turtlebot3_ws/src
WORKDIR /turtlebot3_ws/src

# Clone necessary packages
RUN git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3.git && \
    git clone -b humble https://github.com/ROBOTIS-GIT/ld08_driver.git && \
    git clone -b humble https://github.com/ROBOTIS-GIT/coin_d4_driver.git

# Remove parts not needed (as per instructions)
RUN rm -rf turtlebot3/turtlebot3_cartographer turtlebot3/turtlebot3_navigation2

# Build the workspace
WORKDIR /turtlebot3_ws
ENV MAKEFLAGS="-j1" \
	CMAKE_BUILD_PARALLEL_LEVEL=1 \
	COLCON_TRACE=1 \
	COLCON_LOG_LEVEL=info
# Build (So it's inside the image, but dang is that a problem lol)
RUN /bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash && \
	colcon build \
		--symlink-install \
		--parallel-workers 1 \
		--executor sequential \
		--cmake-args -DCMAKE_BUILD_TYPE=MinSizeRel \
"

RUN echo 'export LDS_MODEL=LDS-02' >> ~/.bashrc
#RUN echo 'source /opt/ros/humble/setup.bash' >> ~/.bashrc
RUN echo "source /turtlebot3_ws/install/setup.bash" >> ~/.bashrc

RUN apt-get update && \
	apt-get install -y ros-humble-joy ros-humble-teleop-twist-joy

# Setup entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
