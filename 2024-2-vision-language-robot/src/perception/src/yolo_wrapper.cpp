#include <ros/ros.h>
#include <custom_msgs/Detections.h>

void detectionsCallback(const custom_msgs::Detections::ConstPtr& msg) {
    for (auto &det : msg->detections) {
        ROS_INFO("Detected: %s (conf: %.2f) at [%.2f, %.2f, %.2f, %.2f]", 
                 det.cls_name.c_str(), det.confidence, det.x_min, det.y_min, det.x_max, det.y_max);
    }
}

int main(int argc, char** argv) {
    ros::init(argc, argv, "detection_listener");
    ros::NodeHandle nh;

    ros::Subscriber sub = nh.subscribe("/detected_objects", 1, detectionsCallback);
    ros::spin();

    return 0;
}