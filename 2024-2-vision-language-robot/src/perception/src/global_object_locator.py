#!/usr/bin/env python3
import rospy
import tf2_ros
import tf2_geometry_msgs
from sensor_msgs.msg import Image, CameraInfo
from nav_msgs.msg import Odometry
from custom_msgs.msg import Detections, ObjectPosition, Detection
from cv_bridge import CvBridge
import numpy as np
import math
from image_geometry import PinholeCameraModel
from geometry_msgs.msg import PointStamped

class GlobalObjectLocator:
    def __init__(self):
        rospy.init_node('global_object_locator', anonymous=True)

        # Parameters (adjust as needed)
        self.camera_frame = rospy.get_param('~camera_frame', 'd435_color_optical_frame')
        self.base_frame = rospy.get_param('~base_frame', 'trunk')
        self.global_frame = rospy.get_param('~global_frame', 'odom')  # or 'odom' depending on your setup
        self.depth_topic = rospy.get_param('~depth_topic', '/d435/depth/image_raw')
        self.camera_info_topic = rospy.get_param('~camera_info_topic', '/d435/color/camera_info')
        self.detections_topic = rospy.get_param('~detections_topic', '/detected_objects')
        self.odom_topic = rospy.get_param('~odom_topic', '/odom')  # If you rely on odometry for global pose
        self.object_pose_pub = rospy.Publisher('/global_object_position', PointStamped, queue_size=10)

        # Subscribers
        self.bridge = CvBridge()
        self.depth_image = None
        self.camera_info = None
        self.odom_msg = None

        rospy.Subscriber(self.depth_topic, Image, self.depth_callback, queue_size=1)
        rospy.Subscriber(self.camera_info_topic, CameraInfo, self.camera_info_callback, queue_size=1)
        rospy.Subscriber(self.detections_topic, Detections, self.detections_callback, queue_size=1)
        rospy.Subscriber(self.odom_topic, Odometry, self.odom_callback, queue_size=1)

        # TF Buffer and listener
        self.tf_buffer = tf2_ros.Buffer()
        self.tf_listener = tf2_ros.TransformListener(self.tf_buffer)

        # Camera model
        self.cam_model = PinholeCameraModel()

    def depth_callback(self, msg):
        self.depth_image = self.bridge.imgmsg_to_cv2(msg, desired_encoding="passthrough")
        self.depth_stamp = msg.header.stamp

    def camera_info_callback(self, msg):
        if self.camera_info is None:
            self.camera_info = msg
            self.cam_model.fromCameraInfo(msg)

    def odom_callback(self, msg):
        # If needed to confirm global pose. Usually TF gives global transforms.
        self.odom_msg = msg

    def detections_callback(self, detections_msg):
        # Ensure we have everything we need
        if self.depth_image is None or self.camera_info is None:
            return

        # For each detection, compute global position
        for det in detections_msg.detections:
            # Compute the center pixel of the bounding box
            u = int((det.x_min + det.x_max) / 2.0)
            v = int((det.y_min + det.y_max) / 2.0)

            # Get depth at that pixel (ensure it’s within image bounds)
            if u < 0 or u >= self.depth_image.shape[1] or v < 0 or v >= self.depth_image.shape[0]:
                rospy.logwarn("Detection pixel out of depth image bounds.")
                continue

            depth = self.depth_image[v, u]
            if math.isnan(depth) or depth <= 0:
                rospy.logwarn("Invalid depth at pixel.")
                continue

            # Back-project this pixel to 3D camera coordinates
            X_c, Y_c, Z_c = self.project_pixel_to_3d(u, v, depth)

            # Create a PoseStamped in camera frame to transform it
            object_pose_cam = tf2_geometry_msgs.PoseStamped()
            object_pose_cam.header.frame_id = self.camera_frame
            object_pose_cam.header.stamp = detections_msg.header.stamp
            object_pose_cam.pose.orientation.w = 1.0
            object_pose_cam.pose.position.x = X_c
            object_pose_cam.pose.position.y = Y_c
            object_pose_cam.pose.position.z = Z_c

            try:
                transform = self.tf_buffer.lookup_transform(self.global_frame,
                                                            self.camera_frame,
                                                            detections_msg.header.stamp,
                                                            rospy.Duration(1.0))
                object_pose_global = tf2_geometry_msgs.do_transform_pose(object_pose_cam, transform)

                x_global = object_pose_global.pose.position.x
                y_global = object_pose_global.pose.position.y

                # Publish the object position only after successful transform
                pos_msg = ObjectPosition()
                pos_msg.header = object_pose_global.header
                pos_msg.class_name = det.cls_name
                pos_msg.x = x_global
                pos_msg.y = y_global
                self.object_position_pub.publish(pos_msg)

            except Exception as e:
                rospy.logwarn("Failed to transform object pose: " + str(e))
            
            # Publish the object position as a PointStamped message
            rospy.loginfo(f"Published global position of {det.cls_name} at ({x_global:.2f}, {y_global:.2f})")

    def project_pixel_to_3d(self, u, v, depth):
        # Using pinhole camera model
        X_c = (u - self.cam_model.cx()) * depth / self.cam_model.fx()
        Y_c = (v - self.cam_model.cy()) * depth / self.cam_model.fy()
        Z_c = depth
        return X_c, Y_c, Z_c

if __name__ == '__main__':
    locator = GlobalObjectLocator()
    rospy.spin()
