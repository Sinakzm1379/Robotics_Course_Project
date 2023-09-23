import time
import serial
import numpy as np
from vpython import *

arduino_data = serial.Serial('COM4',115200)
time.sleep(1)

toRad = np.pi/180.0
toDeg = 1/toRad

# Pong game simulation using VPython here

roomX=12
roomY=10
roomZ=20
wallT=.5
wallColor=vector(1,1,1)
wallOpacity=.8
frontOpacity=.1
marbleR=.5
ballColor=vector(0,0,1)

myFloor=box(size=vector(roomX,wallT,roomZ),pos=vector(0,-roomY/2,0),color=wallColor,opacity=wallOpacity)
myCeiling=box(size=vector(roomX,wallT,roomZ),pos=vector(0,roomY/2,0),color=wallColor,opacity=wallOpacity)
leftWall=box(size=vector(wallT,roomY,roomZ),pos=vector(-roomX/2,0,0),color=wallColor,opacity=wallOpacity)
rightWall=box(size=vector(wallT,roomY,roomZ),pos=vector(roomX/2,0,0),color=wallColor,opacity=wallOpacity)
backWall=box(size=vector(roomX,roomY,wallT),pos=vector(0,0,-roomZ/2),color=wallColor,opacity=wallOpacity)
frontWall=box(size=vector(roomX,roomY,wallT),pos=vector(0,0,roomZ/2),color=wallColor,opacity=frontOpacity)
marble=sphere(color=ballColor,radius=marbleR)

paddleX=2
paddleY=2
paddleZ=.2
paddleOpacity=.8
paddleColor=vector(0,.8,.6)
paddle=box(size=vector(paddleX,paddleY,paddleZ),pos=vector(0,0,roomZ/2),color=paddleColor,opacity=paddleOpacity)

marbleX=0
deltaX=.05

marbleY=0
deltaY=.05

marbleZ=0
deltaZ=.05

padX = 0
padY = 0

C = 0
SD = True

while SD:
    while arduino_data.inWaiting() == 0:
        pass
    data_packet = arduino_data.readline()
    try:
        data_packet = str(data_packet, 'utf-8')
        split_packet = data_packet.split("\t")
        # roll = float(splitPacket[0])
        # pitch = float(splitPacket[1])
        # yaw = float(splitPacket[2])
        x = float(split_packet[0])
        y = float(split_packet[1])
        z = float(split_packet[2])
        print('Roll\tPitch\tYaw')
        print(x*toDeg,"\t", y*toDeg,"\t", z*toDeg)
        padX +=(roomX/1023.)*x/5
        padY += (-roomY/1023.)*y/5

        if padX >= (roomX/2-wallT/2):
            padX = roomX/2-wallT/2
        elif padX <= (-roomX/2+wallT/2):
            padX = -roomX/2+wallT/2
        
        if padY >= (roomY/2-wallT/2):
            padY = roomY/2-wallT/2
        elif padY <= (-roomY/2+wallT/2):
            padY = -roomY/2+wallT/2

        if C >= 200:
            marbleX = marbleX+deltaX
            marbleY = marbleY+deltaY
            marbleZ = marbleZ+deltaZ


        if marbleX+marbleR>(roomX/2-wallT/2) or marbleX-marbleR<(-roomX/2+wallT/2):
            deltaX=deltaX*(-1)
            marbleX=marbleX+deltaX

        if marbleY+marbleR>(roomY/2-wallT/2) or marbleY-marbleR<(-roomY/2+wallT/2):
            deltaY=deltaY*(-1)
            marbleY=marbleY+deltaY

        if marbleZ-marbleR<(-roomZ/2+wallT/2):
            deltaZ=deltaZ*(-1)
            marbleZ=marbleZ+deltaZ

        if marbleZ+marbleR>(roomZ/2-wallT/2):
            if marbleX-marbleR < (padX+paddleX/2) and marbleX+marbleR > (padX-paddleX/2) and marbleY-marbleR < (padY+paddleY/2) and marbleY+marbleR > (padY-paddleY/2):
                deltaZ=deltaZ*(-1)
                marbleZ=marbleZ+deltaZ
            else:
                SD = False
                break

        marble.pos=vector(marbleX,marbleY,marbleZ)
        paddle.pos=vector(padX,padY,roomZ/2)
        C += 1
        
    except:
        pass