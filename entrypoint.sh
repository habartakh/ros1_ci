#!/bin/bash
set -e

# Source ROS and your workspace
source /catkin_ws/devel/setup.bash


# Launch Gazebo in the background
echo "Starting Gazebo..."
roslaunch tortoisebot_gazebo tortoisebot_playground.launch &
GAZEBO_PID=$!

# Optionally sleep to allow Gazebo to load
sleep 5

# Start the ROS action server
echo "Launching Tortoisebot Waypoints action server..."
rosrun tortoisebot_waypoints tortoisebot_action_server.py &
SERVICE_PID=$!

# Wait a bit before starting test
sleep 20

# Run the test file 
echo "Running test file..."
rostest tortoisebot_waypoints waypoints_test.test --reuse-master
TEST_PID=$?

# After test finishes, shut everything down
echo "Shutting down Gazebo and service server..."
kill $SERVICE_PID || true
kill $GAZEBO_PID || true

# Exit with the result of the test
exit $TEST_RESULT

