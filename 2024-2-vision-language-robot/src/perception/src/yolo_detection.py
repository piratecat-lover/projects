#!/usr/bin/env python3
import rospy
from sensor_msgs.msg import Image
from custom_msgs.msg import Detection, Detections
from cv_bridge import CvBridge
import cv2
import torch

class YoloInferenceNode:
    def __init__(self):
        rospy.init_node('yolo_inference_node')
        self.bridge = CvBridge()
        self.model = torch.hub.load('ultralytics/yolov5', 'custom', path='/home/craip/src/perception/src/yolo_params.pt')
        self.pub = rospy.Publisher('/detected_objects', Detections, queue_size=5)
        # Subscribe to the camera topic - remember path!
        rospy.Subscriber('/d435/color/image_raw', Image, self.callback, queue_size=1)
    
    def callback(self, msg):
        cv_image = self.bridge.imgmsg_to_cv2(msg, "bgr8")
        results = self.model(cv_image)  # Run inference
        detections = results.xyxy[0]    # format: [x_min, y_min, x_max, y_max, confidence, class_id]
        class_names = self.model.names

        det_array = Detections()
        det_array.header = msg.header
        for det in detections:
            x_min, y_min, x_max, y_max, conf, cls_id = det

            d = Detection()
            # Matching message field names and types:
            d.cls_name = class_names[int(cls_id)]          # string
            d.cls_id = int(cls_id)                         # int32
            d.confidence = float(conf)                     # float64

            # The message expects int32 for coordinates, so cast to int
            d.x_min = int(x_min)
            d.y_min = int(y_min)
            d.x_max = int(x_max)
            d.y_max = int(y_max)
            
            det_array.detections.append(d)

        self.pub.publish(det_array)

if __name__ == '__main__':
    node = YoloInferenceNode()
    rospy.spin()