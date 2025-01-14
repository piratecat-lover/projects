cmake_minimum_required(VERSION 3.0.2)
project(perception)

find_package(catkin REQUIRED COMPONENTS
    rospy    
    roscpp
    std_msgs
    sensor_msgs
    gazebo_msgs
    pcl_ros
    geometry_msgs
    nav_msgs
    cv_bridge
    image_geometry
    tf2_ros
    tf2_geometry_msgs
    custom_msgs
    message_generation
)

generate_messages(
    DEPENDENCIES
    std_msgs
    geometry_msgs
)


catkin_package(
  INCLUDE_DIRS include
  CATKIN_DEPENDS roscpp std_msgs
)

include_directories(
  include
  ${catkin_INCLUDE_DIRS}
)

add_executable(collision_detection
 src/collision_detection.cpp
)
target_link_libraries(collision_detection
  ${catkin_LIBRARIES}
)

add_executable(collision_detection_gazebo
 src/collision_detection_gazebo.cpp
)
target_link_libraries(collision_detection_gazebo
  ${catkin_LIBRARIES}
)

# For Python nodes
catkin_install_python(PROGRAMS
  src/yolo_detection.py
  src/global_object_locator.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

# For the C++ node
add_executable(yolo_wrapper src/yolo_wrapper.cpp)
target_link_libraries(yolo_wrapper ${catkin_LIBRARIES})
install(TARGETS yolo_wrapper
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)