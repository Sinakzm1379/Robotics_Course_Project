#!/usr/bin/env python3

import rospy
from geometry_msgs.msg import Twist
from turtlesim.srv import Spawn, SpawnRequest,Kill,KillRequest,SetPen,SetPenRequest
from std_srvs.srv import Empty
import math
import time

def change_background_color_client(r=60,g=60,b=60):
    rospy.set_param('/turtlesim/background_r' , r)
    rospy.set_param('/turtlesim/background_g' , g)
    rospy.set_param('/turtlesim/background_b' , b)
    rospy.wait_for_service('/clear')
    try: 
        change_background_color = rospy.ServiceProxy('/clear', Empty)
        resp = change_background_color()
    except rospy.ServiceException as e:
        rospy.loginfo(f'Service failed with the exception {e}')

def set_pen_turtle(name,r=207,g=181,b=59,w=15,off=0):
    rospy.wait_for_service(name+'/set_pen')
    try:
        set_pen = rospy.ServiceProxy(name+'/set_pen', SetPen)
        server_response = set_pen(r,g,b,w,off)
    except rospy.ServiceException as e:
        rospy.loginfo("Service call failes: %s"%e) 

def kill_default_turtle(name):
    rospy.wait_for_service('/kill')
    try:
        kill_turtle = rospy.ServiceProxy('/kill', Kill)
        server_response = kill_turtle(name)
    except rospy.ServiceException as e:
        rospy.loginfo("Service call failes: %s"%e)

def spawn_turtle_client(x, y, theta, name):
    rospy.wait_for_service('/spawn')
    try:
        spawn_turtle = rospy.ServiceProxy('/spawn', Spawn)
        server_response = spawn_turtle(x, y, theta, name)
    except rospy.ServiceException as e:
        rospy.loginfo("Service call failes: %s"%e) 

def Celebrate_turtle():
    vel_msg_r = Twist()
    vel_msg_r.angular.z = math.radians(90)
    rate = rospy.Rate(120)
    
    t0 = rospy.Time().now().to_sec()
    current_angle = 0
    while current_angle <= math.radians(900):
        pub1.publish(vel_msg_r)
        pub2.publish(vel_msg_r)
        pub3.publish(vel_msg_r)
        pub4.publish(vel_msg_r)

        t1 = rospy.Time().now().to_sec() - t0
        current_angle = t1 * vel_msg_r.angular.z
        rate.sleep()            

def ZeroAngle(theta0,dir,name):
    vel_msg_r = Twist()
    vel_msg_r.angular.z = dir*math.radians(theta0)
    rate = rospy.Rate(120)
    
    t0 = rospy.Time().now().to_sec()
    current_angle = 0
    rospy.loginfo("Turtle is rotating ...")
    while current_angle <= math.radians(theta0):
        name.publish(vel_msg_r)

        t1 = rospy.Time().now().to_sec() - t0
        current_angle = dir * t1 * vel_msg_r.angular.z
        #print(f"The current angle : {math.degrees(current_angle)} degress")
        rate.sleep()        

def DrawName():
    # Default Func
    vel_msg = Twist()
    rate = rospy.Rate(120)
# Draw S:
    # initial data
    vel_msg.linear.x = 2.5
    vel_msg.angular.z = math.radians(90)
    set_pen_turtle('S')
    #set_pen_turtle(r,g,b,w,off)
    ZeroAngle(89,-1,pub1)
    t0 = rospy.Time().now().to_sec()
    current_angle = 0
    dir = 1
    # Draw
    rospy.loginfo("Turtle is drawing S...")
    while current_angle <= math.radians(385):
        pub1.publish(vel_msg)

        t1 = rospy.Time().now().to_sec() - t0
        current_angle = dir * t1 * vel_msg.angular.z
        if current_angle >= math.radians(255):
            vel_msg.angular.z = -math.radians(90)
            dir = -1
        #print(f"The current angle : {math.degrees(dir*current_angle)} degress")
        rate.sleep()
    vel_msg.angular.z = 0

# Draw I:
    # initial data
    vel_msg.linear.x = 2.5
    ZeroAngle(88,1,pub2)
    t0 = rospy.Time().now().to_sec()
    current_distance = 0
    set_pen_turtle('I')
    # Draw
    rospy.loginfo("Turtle is drawing I...")
    while current_distance <= 3.5:
        pub2.publish(vel_msg)

        t1 = rospy.Time().now().to_sec() - t0
        current_distance = t1 * vel_msg.linear.x
        #print(f"The current distance : {current_distance} ")
        rate.sleep()

# Draw N:
    # Default Func
    vel_msg = Twist()
    rate = rospy.Rate(120)
    # initial data
    vel_msg.linear.x = 2.5
    ZeroAngle(88,1,pub3)
    t0 = rospy.Time().now().to_sec()
    current_distance = 0
    dir = 1
    set_pen_turtle('N')
    # Draw1
    rospy.loginfo("Turtle is drawing N...")
    while current_distance <= 6:
        pub3.publish(vel_msg)

        t1 = rospy.Time().now().to_sec() - t0
        current_distance = dir * t1 * vel_msg.linear.x
        #print(f"The current distance : {current_distance} ")
        rate.sleep()
    # Draw2
    ZeroAngle(160,-1,pub3)
    t0 = rospy.Time().now().to_sec()
    current_distance = 0
    while current_distance <= 6.35:
        pub3.publish(vel_msg)

        t1 = rospy.Time().now().to_sec() - t0
        current_distance = dir * t1 * vel_msg.linear.x
        #print(f"The current distance : {current_distance} ")
        rate.sleep()
    # Draw3
    ZeroAngle(160,1,pub3)
    t0 = rospy.Time().now().to_sec()
    current_distance = 0
    while current_distance <= 3.5:
        pub3.publish(vel_msg)

        t1 = rospy.Time().now().to_sec() - t0
        current_distance = dir * t1 * vel_msg.linear.x
        #print(f"The current distance : {current_distance} ")
        rate.sleep()

# Draw A:
    # Default Func
    vel_msg = Twist()
    rate = rospy.Rate(120)
    # initial data
    vel_msg.linear.x = 2.5
    ZeroAngle(75,1,pub4)
    t0 = rospy.Time().now().to_sec()
    current_distance = 0
    dir = 1
    set_pen_turtle('A')
    # Draw1
    rospy.loginfo("Turtle is drawing A...")
    while current_distance <= 6.35:
        pub4.publish(vel_msg)

        t1 = rospy.Time().now().to_sec() - t0
        current_distance = dir * t1 * vel_msg.linear.x
        #print(f"The current distance : {current_distance} ")
        rate.sleep()
    # Draw2
    ZeroAngle(150,-1,pub4)
    t0 = rospy.Time().now().to_sec()
    current_distance = 0
    while current_distance <= 4.35:
        pub4.publish(vel_msg)

        t1 = rospy.Time().now().to_sec() - t0
        current_distance = dir * t1 * vel_msg.linear.x
        #print(f"The current distance : {current_distance} ")
        rate.sleep()
    # Draw3
    ZeroAngle(105,-1,pub4)
    t0 = rospy.Time().now().to_sec()
    current_distance = 0
    while current_distance <= 2.1:
        pub4.publish(vel_msg)

        t1 = rospy.Time().now().to_sec() - t0
        current_distance = dir * t1 * vel_msg.linear.x
        #print(f"The current distance : {current_distance} ")
        rate.sleep()
    # Draw4
    ZeroAngle(180,1,pub4)
    t0 = rospy.Time().now().to_sec()
    current_distance = 0
    while current_distance <= 2.05:
        pub4.publish(vel_msg)

        t1 = rospy.Time().now().to_sec() - t0
        current_distance = dir * t1 * vel_msg.linear.x
        #print(f"The current distance : {current_distance} ")
        rate.sleep() 
    # Draw5
    ZeroAngle(75,-1,pub4)
    vel_msg.linear.x = 2
    pub4.publish(vel_msg)
    rate.sleep()  

if __name__=='__main__':

    #initial node
    rospy.init_node('Turtle_move')
    change_background_color_client()
    #killing default turtle
    rospy.loginfo("killing default turtle...")
    kill_default_turtle("turtle1")
    rospy.loginfo("Turtle1 has killed!")
    #making turtles
    rospy.loginfo("Calling Spawn Service!")
    spawn_turtle_client(0.5, 2.0, 0.0, "S")
    rospy.loginfo("Turtle S has spawned!")
    pub1 = rospy.Publisher('/S/cmd_vel',Twist,queue_size=20)

    spawn_turtle_client(4.5, 1.0, 0.0, "I")
    rospy.loginfo("Turtle I has spawned!")
    pub2 = rospy.Publisher('/I/cmd_vel',Twist,queue_size=20)

    spawn_turtle_client(5, 1.0, 0.0, "N")
    rospy.loginfo("Turtle N has spawned!")
    pub3 = rospy.Publisher('/N/cmd_vel',Twist,queue_size=20)

    spawn_turtle_client(7.5, 1.0, 0.0, "A")
    rospy.loginfo("Turtle A has spawned!")
    pub4 = rospy.Publisher('/A/cmd_vel',Twist,queue_size=20)
    #Drawing
    DrawName()
    #Clear the screen
    rospy.loginfo("killing turtles...")
    time.sleep(1.5)
    service_response = kill_default_turtle("S")
    rospy.loginfo("Turtle S has killed!")
    service_response = kill_default_turtle("I")
    rospy.loginfo("Turtle I has killed!")
    service_response = kill_default_turtle("N")
    rospy.loginfo("Turtle N has killed!")
    service_response = kill_default_turtle("A")
    rospy.loginfo("Turtle A has killed!")
    #Celebrating
    rospy.loginfo("Celebrating!")
    service_response = spawn_turtle_client(2.5, 9, 0.0, "S")
    service_response = spawn_turtle_client(4.5, 9, 0.0, "I")
    service_response = spawn_turtle_client(6.5, 9, 0.0, "N")
    service_response = spawn_turtle_client(8.5, 9, 0.0, "A")
    Celebrate_turtle()