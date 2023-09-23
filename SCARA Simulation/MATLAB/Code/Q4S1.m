clc
XYZ = XYZPose.Data;
plot(XYZ(:,1),XYZ(:,2),Color=[0.0 0.4 0.4])
xlabel("X Axis")
ylabel("Y Axis")
title("EdnEff Path")
xlim([0.1 0.5])
ylim([0.1 0.5])
