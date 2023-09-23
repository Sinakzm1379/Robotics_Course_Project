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
        qw = float(split_packet[0])
        qx = float(split_packet[1])
        qy = float(split_packet[2])
        qz = float(split_packet[3])
        print('qw\tqx\tqy\tqz')
        print(qw,"\t", qx,"\t", qy,"\t",qz)


        q0 = qw
        q1 = qx
        q2 = qy
        q3 = qz
        
        # First row of the rotation matrix
        r00 = 2 * (q0 * q0 + q1 * q1) - 1
        r01 = 2 * (q1 * q2 - q0 * q3)
        r02 = 2 * (q1 * q3 + q0 * q2)
        
        # Second row of the rotation matrix
        r10 = 2 * (q1 * q2 + q0 * q3)
        r11 = 2 * (q0 * q0 + q2 * q2) - 1
        r12 = 2 * (q2 * q3 - q0 * q1)
        
        # Third row of the rotation matrix
        r20 = 2 * (q1 * q3 - q0 * q2)
        r21 = 2 * (q2 * q3 + q0 * q1)
        r22 = 2 * (q0 * q0 + q3 * q3) - 1
        
        # 3x3 rotation matrix
        R = np.array([[r00, r01, r02],
                            [r10, r11, r12],
                            [r20, r21, r22]])
                            
        print('Rotation Matrix : ')
        print(R,"\n")

    except:
        pass