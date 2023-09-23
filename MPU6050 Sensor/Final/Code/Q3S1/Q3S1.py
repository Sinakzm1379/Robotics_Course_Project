import time
import math
import serial
import numpy as np
from vpython import *

arduino_data = serial.Serial('COM4', 115200)
time.sleep(1)
toRad = np.pi/180.0
toDeg = 1/toRad

while True:
    while arduino_data.inWaiting() == 0:
        pass
    data_packet = arduino_data.readline()
    try:
        data_packet = str(data_packet, 'utf-8')
        split_packet = data_packet.split("\t")
        roll = float(split_packet[0])*toRad
        pitch = float(split_packet[1])*toRad
        yaw = float(split_packet[2])*toRad
        print('Roll\tPitch\tYaw')
        print(roll*toDeg,"\t", pitch*toDeg,"\t", yaw*toDeg)

        yawMatrix = np.matrix([
        [math.cos(yaw), -math.sin(yaw), 0],
        [math.sin(yaw), math.cos(yaw), 0],
        [0, 0, 1]
        ])

        pitchMatrix = np.matrix([
        [math.cos(pitch), 0, math.sin(pitch)],
        [0, 1, 0],
        [-math.sin(pitch), 0, math.cos(pitch)]
        ])

        rollMatrix = np.matrix([
        [1, 0, 0],
        [0, math.cos(roll), -math.sin(roll)],
        [0, math.sin(roll), math.cos(roll)]
        ])

        R = yawMatrix * pitchMatrix * rollMatrix
        print('Rotation Matrix : ')
        print(R,"\n")

    except:
        pass