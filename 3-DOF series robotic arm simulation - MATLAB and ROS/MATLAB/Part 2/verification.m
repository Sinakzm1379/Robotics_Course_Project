close all;
clc;

T=linspace(0,10,1e4);

theta1=sin(T)-pi/2;
theta2=0.5*sin(T)+pi/2;
theta3=sin(T);

dtheta1=sin(T+pi/2);
dtheta2=0.5*sin(T+pi/2);
dtheta3=sin(T+pi/2);

ddtheta1=sin(T+pi);
ddtheta2=0.5*sin(T+pi);
ddtheta3=sin(T+pi);

torques=zeros(3,1e4);
for i=1:1e4
    torques(:,i)=Torques2(ddtheta1(i),ddtheta2(i),ddtheta3(i),dtheta1(i),dtheta2(i),dtheta3(i),theta1(i),theta2(i),theta3(i));
end
markers = {'default','-.','--',':'};
plot(T,torques,'LineStyle',markers{1},'LineWidth',3);
hold on
plot(out.torques.Time,out.torques.Data,'LineStyle',markers{4},'LineWidth',2);
legend('Τ_{1}','Τ_{2}','Τ_{3}','Τ1_{sim}','Τ2_{sim}','Τ3_{sim}');
title('joints torque using simscape and dynamic model')
xlabel('t')
ylabel('\tau (N.m)')