# Base image
FROM osrf/ros:noetic-desktop-full-focal

# Install Gazebo 11 and other dependencies
RUN apt-get update && apt-get install -y \
  git \
  gazebo11 \
  ros-noetic-gazebo-ros-pkgs \
  ros-noetic-gazebo-ros-control \
  ros-noetic-ros-control \
  ros-noetic-ros-controllers \
  ros-noetic-joint-state-publisher \
  ros-noetic-joint-state-controller \
  ros-noetic-robot-state-publisher \
  ros-noetic-robot-localization \
  ros-noetic-xacro \
  ros-noetic-tf2-ros \
  ros-noetic-tf2-tools \
  && rm -rf /var/lib/apt/lists/*

# make workspace
WORKDIR /
RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws/src

# Copy the files in the current directory into the container
COPY ./tortoisebot/ /catkin_ws/src/tortoisebot
COPY ./tortoisebot_waypoints/ /catkin_ws/src/tortoisebot_waypoints
COPY ./entrypoint.sh /catkin_ws/ros_entrypoint.sh

# # Add the tortoisebot testing package from git
# RUN git clone https://github.com/habartakh/tortoisebot_waypoints.git

# Set environment variables
ENV DISPLAY=:1
ENV GAZEBO_MASTER_URI=${GAZEBO_MASTER_URI}
ENV ROS_DOMAIN_ID=1

# Source ros noetic and build workspace
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && cd /catkin_ws && catkin_make"

# Source the setup.bash file before executing further commands
RUN echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc

WORKDIR /catkin_ws

# Execute the following bash script upon starting a container 
# ENTRYPOINT ["/ros_entrypoint.sh"]

# /bin/bash is the command we want to execute when running a docker container
# ENTRYPOINT ["/bin/bash"]

# We want /bin/bash to execute our /entrypoint.sh when container starts
# CMD ["bash ros_entrypoint.sh"]

# Start a bash shell when the container starts
CMD ["/bin/bash", "-c","bash ros_entrypoint.sh"]