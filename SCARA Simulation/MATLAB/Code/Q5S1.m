clc
%% Code

c=0;
for t1 = -20:0.1:110
    for t2 = -60:0.1:240
        c=c+1;
        x(c) = 0.5*cosd(t1) + 0.5*cosd(t2+t1);
        y(c) = 0.5*sind(t1) + 0.5*sind(t2+t1);
    end
end
figure(1)
scatter(x,y,'.',Color=[0.0 0.4 0.4]);
xlabel("X Axis")
ylabel("Y Axis")
title("EdnEff Workspace")

%% Test
XYZ = XYZPose.Data;
figure(2)
plot(XYZ(:,1),XYZ(:,2),Color=[0.0 0.4 0.4])
xlabel("X Axis")
ylabel("Y Axis")
title("EdnEff Path")

degj1 = DegJ1.Data;
degj2 = DegJ2.Data;
figure(3)
plotj1 = plot(degj1*(180/pi));
maxj1 = max(plotj1.YData)
minj1 = min(plotj1.YData)
figure(4)
plotj2 = plot(degj2*(180/pi));
maxj2 = max(plotj2.YData)
minj2 = min(plotj2.YData)