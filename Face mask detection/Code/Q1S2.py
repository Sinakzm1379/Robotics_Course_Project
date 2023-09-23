# Lib

from keras.models import load_model
import cv2
import numpy as np
from pathlib import Path
import pandas as pd
from keras.utils import load_img

# Data

# Load the model
MyModel = load_model("Data\model.h5")
# Load the cascade
face_cascade = cv2.CascadeClassifier(r"Data\haarcascade_frontalface_default.xml")
# Path to the directory
data_dir1 = Path("../Q1/Data/archive/NoMask/")
data_dir2 = Path("../Q1/Data/archive/Mask/")
# Get list of all the images and labels
images1 = list(data_dir1.glob("*"))
labels1 = [img_path.name.split(".")[1] for img_path in images1]
images2 = list(data_dir2.glob("*"))
labels2 = [img_path.name.split(".")[1] for img_path in images2]
# Create the dataframe of the path and label
ImageData = []
for i in range(len(images1)):
    ImageData.append((str(images1[i]),labels1[i], "NoMask","None","None"))
for i in range(len(images2)):
    ImageData.append((str(images2[i]),labels2[i], "Mask","None","None"))
ImageData = pd.DataFrame(ImageData,columns=["Image Path","Format", "Label","Test Result","Test Percent"], index=None)

# Mask Detection

results={0:'without mask',1:'mask'}
GR_dict={0:(0,0,255),1:(0,255,0)}
rect_size = 4
Border = 0.5
for i in range(len(ImageData)):
    # read image
    img = cv2.imread(str(ImageData["Image Path"][i]))
    timg = load_img(str(ImageData["Image Path"][i]))
    # resize image
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    # resize image
    rerect_size = cv2.resize(gray, (img.shape[1] // rect_size, img.shape[0] // rect_size))
    # Detect faces
    faces = face_cascade.detectMultiScale(rerect_size)
    Testresult = []
    Percresult = []
    if len(faces) > 0:
        for f in faces:
            (x, y, w, h) = [v * rect_size for v in f]
            y0, y1, x0, x1 = int(y-0.25*h),int(y+1.25*h), int(x-0.25*w),int(x+1.25*w)
            # focus on the face
            if (y0)<0: y0 = 1
            if (y1)>img.shape[0] : y1 = img.shape[0]-1
            if (x0)<0: x0 = 1
            if (x1)>img.shape[1] : x1 = img.shape[1]-1
            face_img = timg.crop((x0,y0,x1,y1))
            # resize the face
            rerect_sized = face_img.resize([150,150])
            arrayimg = np.array(rerect_sized)
            reshaped = np.reshape(arrayimg,(1,150,150,3))
            # predict mask
            result = MyModel.predict(reshaped)
            # tag label
            if result[0][0] <= Border: label = 1
            else: label = 0
            Percent = int(result[0][0]*1000)/10
            Percresult.append(Percent)
            Testresult.append(results[label])
    else:
        face_img = timg
        # resize the face
        rerect_sized = timg.resize([150,150])
        arrayimg = np.array(rerect_sized)
        reshaped = np.reshape(arrayimg,(1,150,150,3))
        # predict mask
        result = MyModel.predict(reshaped)
        # tag label
        if result[0][0] <= Border: label = 1
        else: label = 0
        Percent = int(result[0][0]*1000)/10
        Percresult.append(Percent)
        Testresult.append(results[label])
    if len(Testresult)==1 :
        ImageData["Test Result"][i] = Testresult[0]
        ImageData["Test Percent"][i] = Percresult[0]
    else:
        ImageData["Test Result"][i] = Testresult
        ImageData["Test Percent"][i] = Percresult

# Accuracy

NoMasks = ImageData[ImageData["Label"]=='NoMask']['Test Result'].value_counts(normalize=True).copy()
Masks  = ImageData[ImageData["Label"]=='Mask']['Test Result'].value_counts(normalize=True).copy()
True_Mask = Masks[0]
False_Mask = Masks[1]
True_NoMask = NoMasks[0]
False_NoMask = NoMasks[1]
print(f'The percent of True Mask is {True_Mask:0.2f}')
print(f'The percent of False Mask is {False_Mask:0.2f}')
print(f'The percent of True NoMask is {True_NoMask:0.2f}')
print(f'The percent of False NoMask is {False_NoMask:0.2f}')