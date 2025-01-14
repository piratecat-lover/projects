#! /usr/bin/env python3
import os
import os.path as osp
import sys
import ast
from custom_msgs.msg import ObjectPosition
from geometry_msgs.msg import PointStamped

vlmaps_pkg_path = osp.dirname(osp.dirname(osp.abspath(__file__)))
source_path = osp.dirname(vlmaps_pkg_path)
sys.path.append(osp.dirname(osp.abspath(__file__)))
sys.path.append(source_path)

import rospy
from std_msgs.msg import Bool, String
from geometry_msgs.msg import Point
from nav_msgs.msg import Odometry

from filter_subgoal_coord import SubgoalCoordinateFilter

class SCFArgs():
    def __init__(self):
        rospy.init_node('subgoal_coordinate_filter_node', anonymous=True)
        rospy.loginfo('get arguments for subgoal coordinate filter....')

        self.data_path = rospy.get_param(rospy.get_name() + '/data_path')
        self.mask_version = rospy.get_param(rospy.get_name() + '/mask_version')
        self.clip_version = rospy.get_param(rospy.get_name() + '/clip_version')
        self.min_area = rospy.get_param(rospy.get_name() + '/min_area')
        self.max_area = rospy.get_param(rospy.get_name() + '/max_area')
        self.margin = rospy.get_param(rospy.get_name() + '/margin')
        self.do_crop = rospy.get_param(rospy.get_name() + '/do_crop')
        self.device = rospy.get_param(rospy.get_name() + '/device')
        self.raycast_resolution = rospy.get_param(rospy.get_name() + '/raycast_resolution')
        self.goal_arrived_thresh = rospy.get_param('/goal_arrived_thresh')
        self.map_resolution = rospy.get_param('/map_resolution')
        
        self.landmarks_list_path = rospy.get_param(rospy.get_name() + '/landmarks_list_path')


class SCFWrapper():
    def __init__(self, args):
        # subgoal coordinate filter
        self.scf = SubgoalCoordinateFilter(args)
        
        # ROS
        rospy.loginfo('starting subgoal coordinate filter node....')
        subgoal_topic = rospy.get_param('subgoal_topic')
        subgoal_text_topic = rospy.get_param('subgoal_text_topic')
        subgoal_arrived_topic = rospy.get_param('subgoal_arrived_topic')
        localization_topic = rospy.get_param('localization_topic')
        success_topic = rospy.get_param('success_topic')
        reset_topic = rospy.get_param('reset_topic')
        self._method = rospy.get_param('method')
        self._resolution = rospy.get_param('map_resolution')
        self._prompt_type = rospy.get_param('prompt_type')
        self.goal_pub = rospy.Publisher(subgoal_topic, Point, queue_size=10)
        self.goal_text_pub = rospy.Publisher(subgoal_text_topic, String, queue_size=10)
        self.arrival_sub = rospy.Subscriber(subgoal_arrived_topic, Bool, self.arrival_signal_callback)
        self.localization_sub = rospy.Subscriber(localization_topic, Odometry, self.localization_callback)
        self.success_pub = rospy.Publisher(success_topic, Bool, queue_size=10)
        self.reset_sub = rospy.Subscriber(reset_topic, Bool, self.reset_callback)
        # Subscribe to YOLO-based global positions
        self.object_pos_sub = rospy.Subscriber('/object_positions', ObjectPosition, self.object_position_callback)

        # subgoal related info
        self.generate_subgoal = True
        self.robot_pixel_pose = [self.scf.obstacles.shape[1] / 2, self.scf.obstacles.shape[0] / 2]
        self.print_info = False
        self.subgoal_init = False
        
    @staticmethod    
    def load_txt(file):
        with open(file, 'r') as f:
            text = f.read()
        # convert string representation of list to a list
        return ast.literal_eval(text) 
        
    @staticmethod
    def get_file_time(file):
        return os.stat(file).st_ctime

    def _infill_subgoal_list(self):
        for subgoal, coord in list(self.scf.subgoal_dict.items()):
            if self._method in ['vlmap', 'e2map']:
                global_x, global_y = self.convert_to_global_coordinate(coord)
                coord = (global_x, global_y)
            self.subgoal_list.append((subgoal, coord))
    
    def reset_subgoal_list(self):
        self.scf.subgoal_dict.clear()
        self.scf.contour_draw_list.clear()
        self.scf.set_robot_pose(self.robot_pixel_pose)
        
        # code-type output
        if self._prompt_type == 'code':
            assert self._method in ['vlmap', 'e2map'], \
                'code-type output only can be executed in map-type navigation methods (vlmap, e2map)'
            code_list = self.load_txt(args.landmarks_list_path)
            for code in code_list:
                exec(code)
            
        # landmark-only output
        elif self._prompt_type == 'landmark':
            landmark_list = self.load_txt(args.landmarks_list_path)
            for landmark in landmark_list:
                assert 'self.' not in landmark, "landmark should be a single word."
                
                # map-based navigation
                if self._method in ['vlmap', 'e2map']:
                    self.go_to(landmark)
        
                else: 
                    raise ValueError("method should be one of vlmap, e2map")
            
        self.subgoal_list = []
        self._infill_subgoal_list()
        self.index = 0
        self.print_info = False
        
    def go_to(self, landmark: str):
        self.scf.get_landmark_coordinate(landmark)
        
    def go_left_of(self, landmark: str):
        self.scf.get_landmark_coordinate(landmark, 'left')
    
    def go_right_of(self, landmark: str):
        self.scf.get_landmark_coordinate(landmark, 'right')
        
    def go_top_of(self, landmark: str):
        self.scf.get_landmark_coordinate(landmark, 'top')
    
    def go_bottom_of(self, landmark: str):
        self.scf.get_landmark_coordinate(landmark, 'bottom')
        
    def go_between(self, landmark1: str, landmark2: str):
        self.scf.get_coordinate_between_two_landmarks(landmark1, landmark2)
        
    def convert_to_global_coordinate(self, pixel_coord):
        x = pixel_coord[0]
        y = pixel_coord[1]
        
        world_x = (x - self.scf.obstacles.shape[1] / 2) * self._resolution
        world_y = (self.scf.obstacles.shape[0] / 2 - y) * self._resolution
        return (world_x, world_y)
    
    def convert_to_pixel_coordinate(self, world_coord):
        x = world_coord[0]
        y = world_coord[1]
        
        pixel_x = int(x / self._resolution + self.scf.obstacles.shape[1] / 2)
        pixel_y = int(- y / self._resolution + self.scf.obstacles.shape[0] / 2)
        return (pixel_x, pixel_y)
    
    def object_position_callback(self, msg):
        # Only add if class_name is requested in instructions
        if msg.class_name in self.requested_subgoals:
            # convert to pixel coords if needed:
            pixel_x, pixel_y = self.convert_to_pixel_coordinate([msg.x, msg.y])
            self.scf.subgoal_dict[msg.class_name] = [pixel_x, pixel_y]

            rospy.loginfo(f"Added YOLO-detected {msg.class_name} to subgoal_dict at global coords ({msg.x}, {msg.y})")
            # Refresh subgoal list
            self.subgoal_list = []
            self._infill_subgoal_list()
            # If we want to publish immediately:

            
    def publish_goal(self):
        """Pop subgoal from list and publish subgoal's coordinate and name one-by-one until the list is empty."""
        if len(self.subgoal_list) != 0:
            self.subgoal_init = True
            subgoal, subgoal_coord = self.subgoal_list.pop(0)

            coord = Point()
            coord.x = subgoal_coord[0]
            coord.y = subgoal_coord[1]
            coord.z = 0
            
            goal_text = String()
            goal_text.data = subgoal

            rospy.loginfo(f'Publish the <subgoal {self.index + 1}: {subgoal}> coordinate!')
            self.goal_pub.publish(coord)
            self.goal_text_pub.publish(goal_text)

            self.index += 1
            
        else:
            if self.subgoal_init:
                self.subgoal_init = False
                success_msg = Bool()
                success_msg.data = True
                self.success_pub.publish(success_msg)
                
            if not self.print_info:
                rospy.loginfo('No remaining subgoal coordinate!')
                self.print_info = True

    def reset_callback(self, msg):
        reseted = msg.data
        if reseted:
            if os.path.isfile(args.landmarks_list_path):
                os.remove(args.landmarks_list_path)
            self.generate_subgoal = True
            
    def arrival_signal_callback(self, msg):
        arrived = msg.data
        if arrived:
            if not self.print_info:
                rospy.loginfo('Receive the arrival signal')
            self.publish_goal()
            
    def localization_callback(self, msg):
        x = msg.pose.pose.position.x
        y = msg.pose.pose.position.y
        pixel_x, pixel_y = self.convert_to_pixel_coordinate([x, y])
        self.robot_pixel_pose = [pixel_x, pixel_y]
        

if __name__ == "__main__":
    args = SCFArgs()
    wrapper = SCFWrapper(args)
   
    rate = rospy.Rate(10)
    while not rospy.is_shutdown():
        if not os.path.isfile(args.landmarks_list_path):
            print("LIMBO is wating for user instruction...")
        elif wrapper.generate_subgoal:
            wrapper.reset_subgoal_list()
            prev_time = wrapper.get_file_time(args.landmarks_list_path)           
            wrapper.publish_goal()
            wrapper.generate_subgoal = False
        else:
            if prev_time != wrapper.get_file_time(args.landmarks_list_path):
                wrapper.generate_subgoal = True
                
        rate.sleep()