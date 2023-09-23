# Lib
from keras.models import load_model
import cv2
import numpy as np

# Data

# Load the model
MyModel = load_model("Data\model.h5")
# Load the cascade
face_cascade = cv2.CascadeClassifier(r"Data\haarcascade_frontalface_default.xml")

# Mask Detection

results={0:'without mask',1:'mask'}
GR_dict={0:(0,0,255),1:(0,255,0)}
rect_size = 4
Border = 0.5
cap = cv2.VideoCapture(0)
while True:
    # read image
    _, img = cap.read()
    # resize image
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    # resize image
    rerect_size = cv2.resize(gray, (img.shape[1] // rect_size, img.shape[0] // rect_size))
    # Detect faces
    faces = face_cascade.detectMultiScale(rerect_size)
    if len(faces) > 0:
        for f in faces:
            (x, y, w, h) = [v * rect_size for v in f]
            y0, y1, x0, x1 = int(y-0.25*h),int(y+1.25*h), int(x-0.25*w),int(x+1.25*w)
            # focus on the face
            if (y0)<0: y0 = 1
            if (y1)>img.shape[0] : y1 = img.shape[0]-1
            if (x0)<0: x0 = 1
            if (x1)>img.shape[1] : x1 = img.shape[1]-1
            face_img = img[y0:y1,x0:x1]
            # resize the face
            rerect_sized = cv2.resize(face_img,(150,150))
            normalized = rerect_sized/255.0
            reshaped = np.reshape(normalized,(1,150,150,3))
            reshaped = np.vstack([reshaped])
            # predict mask
            result = MyModel.predict(reshaped)
            # tag label
            if result[0][0] >= Border:label = 1
            else: label = 0
            Percent = str(int(result[0][0]*1000)/10) + '%'
            FinalText = results[label] + " - " + Percent
            # show rectangle on image
            cv2.rectangle(img,(x,y),(x+w,y+h),GR_dict[label],2)
            cv2.rectangle(img,(x,y-40),(x+w,y),GR_dict[label],-1)
            cv2.putText(img, FinalText, (x, y-10),cv2.FONT_HERSHEY_SIMPLEX,0.8,(255,255,255),2)
    else:
        face_img = img
        # resize the face
        rerect_sized = cv2.resize(face_img,(150,150))
        normalized = rerect_sized/255.0
        reshaped = np.reshape(normalized,(1,150,150,3))
        reshaped = np.vstack([reshaped])
        # predict mask
        result = MyModel.predict(reshaped)
        # tag label
        if result[0][0] >= Border:label = 1
        else: label = 0
        Percent = str(int(result[0][0]*1000)/10) + '%'
        FinalText = results[label] + " - " + Percent
        cv2.rectangle(img,(10,10),(250,50),GR_dict[label],-1)
        cv2.putText(img, FinalText, (10, 40),cv2.FONT_HERSHEY_SIMPLEX,0.8,(255,255,255),2)
    # Display the output
    cv2.imshow('LIVE', img)
    k = cv2.waitKey(10)
    if k == 27:
        break
cap.release()
cv2.destroyAllWindows()