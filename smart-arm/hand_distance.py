import cv2
from cvzone.HandTrackingModule import HandDetector
import math
import numpy as np
import cvzone
from pyfirmata import util, Arduino
import time

#Webcam
cap = cv2.VideoCapture(1)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1920)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 1080)

# Hand Detector
detector = HandDetector(detectionCon=0.8, maxHands=1);

#Find Function
#x is the raw distance, y is the value in cm
x=[300,245,200,170,145,130,112,103,93,87,80,75,70,67,62,59,57]
y=[20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100]
coff=np.polyfit(x,y,2)

board=Arduino('COM5')
it=util.Iterator(board)
it.start()
servo_theta=board.get_pin('d:9:s')
servo_phi=board.get_pin('d:10:s')
servo_alpha=board.get_pin('d:8:s')
sgrip=board.get_pin('d:11:s')
L_arm=8
l_arm=8
theta=0
phi=0
servo_theta.write(90)
servo_phi.write(0)
servo_alpha.write(90)
sgrip.write(150)

def get_theta(x,y,z):
  d=math.sqrt(x*x+z*z)
  D=math.sqrt(d*d+y*y)
  if(abs((D*D+L_arm*L_arm-l_arm*l_arm)/(2*L_arm*D))<=1):
    t=math.atan(y/d)+math.acos((D*D+L_arm*L_arm-l_arm*l_arm)/(2*L_arm*D))
  else:
    t=90
  return t

def get_phi(x, y, z):
  d=math.sqrt(x*x+z*z)
  D=math.sqrt(d*d+y*y)
  if(abs((D*D+L_arm*L_arm-l_arm*l_arm)/(2*L_arm*D))<=1):
    p=-math.atan(y/d)+math.acos((D*D-L_arm*L_arm+l_arm*l_arm)/(2*l_arm*D))
  else:
    p=0
  return p


def get_alpha(x, z):
  if(x>0):
    a=math.atan(z/x)
  else:
    a=90
  return a

while True:
    success, img=cap.read()
    hands, img = detector.findHands(img)
    img=cv2.resize(img, (1920,1080))
    
    if hands:
        lmList=hands[0]['lmList']
        x,y,w,h=hands[0]['bbox']
        x5,y5,z5=lmList[5]
        x8,y8,z8=lmList[8]
        x9,y9,z9=lmList[9]
        x17,y17,z17=lmList[17]
        distance = int(math.sqrt((y17-y5)**2+(x17-x5)**2+(z17-z5)**2))
        gripdist=int(math.sqrt((y8-y5)**2+(x8-x5)**2+(z8-z5)**2))
        A, B, C = coff
        print(distance)
        distanceCM=A*distance**2+B*distance+C
        grip = False
        conversionRate=33.86666667/1920
        if gripdist<150*35/distanceCM:
            grip = True
        else:
            grip = False
        x_distance = int((640-x9)*conversionRate)
        y_distance=int((360-y9)*conversionRate)
        z_distance=int(distanceCM)
        

        # print(x_distance,y_distance,z_distance,grip)
        x_d=8-x_distance
        y_d=0.5*(z_distance)
        z_d=y_distance+5
        print(x_d,y_d,z_d,grip)
        cvzone.putTextRect(img, f'position:{x_d},{y_d},{z_d}, grip:{grip}',(0,40))
        time.sleep(0.1)
        theta_i=get_theta(x_d,y_d,z_d)*180/3.1415
        phi_i=get_phi(x_d,y_d,z_d)*180/3.1415
        alpha_i=get_alpha(x_d,z_d)*180/3.1415
        # print("ALPHA")
        # print(alpha_i)
        # print("PHI")
        # print(phi_i)
        # print("THETA")
        # print(theta_i)
        if(theta_i+phi_i<180):
          sum_i=theta_i+phi_i
        else:
          sum_i=180
        if(theta_i<90):
          theta_ic=theta_i
        else:
          theta_ic=90
        if(alpha_i<180):
          alpha_ic=alpha_i
        else:
          alpha_ic=180
        if(grip):
          sgrip_ic=120
        else:
          sgrip_ic=150
        servo_theta.write(sum_i)
        servo_phi.write(theta_ic)
        servo_alpha.write(alpha_ic)
        sgrip.write(sgrip_ic)
        
    cv2.imshow("Image", img)
    cv2.waitKey(1)
