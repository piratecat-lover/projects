cmake_minimum_required(VERSION 3.0.2)
project(vlmaps)

find_package(catkin REQUIRED COMPONENTS
    roscpp
    rospy
    std_msgs
    geometry_msgs
    custom_msgs
    nav_msgs
    visualization_msgs
    message_filters
    tf2_ros
    tf2_geometry_msgs
    message_generation
)


generate_messages(
    DEPENDENCIES
    std_msgs
    geometry_msgs
)

catkin_package(
    LIBRARIES vlmaps
)


include_directories(
  ${catkin_INCLUDE_DIRS}
)

catkin_install_python(PROGRAMS
  scripts/map.py
  scripts/pointcloud.py
  scripts/scf_wrapper.py
  scripts/filter_subgoal_coord.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)