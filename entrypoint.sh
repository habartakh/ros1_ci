#!/bin/bash
set -e

# Source ROS 2 and your workspace
source /catkin_ws/devel/setup.bash


# Launch Gazebo in the background (with your world or empty world)
echo "Starting Gazebo..."
roslaunch tortoisebot_gazebo tortoisebot_playground.launch &
GAZEBO_PID=$!

# Optionally sleep to allow Gazebo to load
sleep 5

# Start the ROS 2 service server (custom node or launch file)
echo "Launching Tortoisebot Waypoints service server..."
rosrun tortoisebot_waypoints tortoisebot_action_server.py &
SERVICE_PID=$!

# Wait a bit before starting test
sleep 20

# Run the test file (pytest or launch_testing)
echo "Running test file..."
rostest tortoisebot_waypoints waypoints_test.test --reuse-master

# Wait for background processes to finish if needed
wait $GAZEBO_PID
# wait $SERVICE_PID
