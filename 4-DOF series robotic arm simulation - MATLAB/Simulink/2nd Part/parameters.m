clc
clear all
close all
syms b1 theta2 theta3 b4
syms b1_dot theta2_dot theta3_dot b4_dot b1_ddot theta2_ddot theta3_ddot b4_ddot

%% Physical Data
% Link0
mass_link0 = 0.8;
com_link0_ros = [0.0000000e+00 0.0000000e+00 0.0000000e+00]';
I0_ros = [0.44 , 0.0           , 0.0
            0.0         ,  0.003, 0.0
         0.0 ,  0.0          , 0.44];
% Link1
mass_link1 = 0.8;
com_link1_ros = [0.15 0.08 0.1]';
I1_ros = [2000 , 2.0           , 160
            2.0         ,  3000, 1.0
         160 ,  1.0          , 2000].*(10^(-6));
% Link2
mass_link2 = 1.2;
com_link2_ros = [0.35 0.1 0.25]';
I2_ros = [1600 , -0.25, -1200
     -0.25,  30000, 0.05
     -1200,  0.05, 30000].*(10^(-6));
% Link3
mass_link3 = 0.85;
com_link3_ros = [0.45 0.1 0.3]';
I3_ros = [6000, -0.3, 1300
      -0.3, 15000, -0.3
     1300, -0.3, 12000].*(10^(-6));
% Link4
mass_link4 = 0.15;
com_link4_ros = [0.65 0.02 0.4]';
I4_ros = [3000, 0.07, 0.04
         0.07,  3000,  0.1
         0.04,  0.1,  20].*(10^(-6));

%% Change Varibales
I0 =  I0_ros ;
com0 =  com_link0_ros;
I1 = I1_ros;
com1 = com_link1_ros;
I2 = I2_ros ;
com2 =  com_link2_ros;
I3 =  I3_ros;
com3 = com_link3_ros;
I4 =  I4_ros ;
com4 =  com_link4_ros;

%% D-H Form
% T = [Q,P;0,1];
% Com_dh = T*Com_link
% I_dh = Q*I*Q'

T = [Qx(-pi/2),[0;0;73.5e-3];
    [0,0,0,1]]*[eye(3),[0;0;b1];
    [0,0,0,1]];
a1 = T*[0;0;0;1];
a1 = a1(1:3);

T = T*[Qx(pi/2),[-200e-3;0;0];
    [0,0,0,1]];
com1_dh = T*[com1;1];
com1_dh = com1_dh(1:3);
I1_dh = T(1:3,1:3)*(I1+mass_link1*(T(1:3,4).'*T(1:3,4)*eye(3)-T(1:3,4)*T(1:3,4).'))/T(1:3,1:3);

T = T*[eye(3),[200e-3;80e-3;78e-3];[0,0,0,1]]*[[cos(theta2),-sin(theta2),0;sin(theta2),cos(theta2),0;0,0,1],[0;0;0];[0,0,0,1]];
a2 = T*[0;0;0;1];
a2 = a2(1:3);

T = T*[eye(3),[-73e-3;-83e-3;-79e-3];
    [0,0,0,1]];
com2_dh = T*[com2;1];
com2_dh = com2_dh(1:3);
I2_dh = T(1:3,1:3)*(I2+mass_link2*(T(1:3,4).'*T(1:3,4)*eye(3)-T(1:3,4)*T(1:3,4).'))/T(1:3,1:3);

T = T*[eye(3),[470e-3;90e-3;200e-3];[0,0,0,1]]*[[cos(theta3),-sin(theta3),0;sin(theta3),cos(theta3),0;0,0,1],[0;0;0];[0,0,0,1]];
a3 = T*[0;0;0;1];
a3 = a3(1:3);

T = T*[eye(3),[-400e-3;-90e-3;-200e-3];[0,0,0,1]];
com3_dh = T*[com3;1];
com3_dh = com3_dh(1:3);
I3_dh = T(1:3,1:3)*(I3+mass_link3*(T(1:3,4).'*T(1:3,4)*eye(3)-T(1:3,4)*T(1:3,4).'))/T(1:3,1:3);

T = T*[eye(3),[650e-3;70e-3;280e-3];[0,0,0,1]]*[eye(3),[0;0;b4];[0,0,0,1]];
a4 = T*[0;0;0;1];
a4 = a4(1:3);

T = T*[eye(3),[-650e-3;0;-345e-3];[0,0,0,1]];
com4_dh = T*[com4;1];
com4_dh = com4_dh(1:3);
I4_dh = T(1:3,1:3)*(I4+mass_link4*(T(1:3,4).'*T(1:3,4)*eye(3)-T(1:3,4)*T(1:3,4).'))/T(1:3,1:3);

%% First dot

W1 = [0;0;0];
N1 = [0;b1_dot;0];

W2 = [0;0;theta2_dot];
N2 = N1 + cross(W2,com2_dh-a2);

W3 = [0;0;theta3_dot];
N3 = N1+cross(W2,a3-a2)+cross(W3,com3_dh-a3);

W4 = [0;0;0];
N4 = N1 + cross(W2,a3-a2)+cross(W3,com4_dh-a3)+[0;0;b4_dot];

%% Final calculation

T1 = 0.5 * mass_link1 * N1'*N1 + 0.5 * W1'*I1_dh*W1;
T2 = 0.5 * mass_link2 * N2'*N2 + 0.5 * W2'*I2_dh*W2;
T3 = 0.5 * mass_link3 * N3'*N3 + 0.5 * W3'*I3_dh*W3;
T4 = 0.5 * mass_link4 * N4'*N4 + 0.5 * W4'*I4_dh*W4;
T = T1 + T2 + T3 + T4;

g = 9.81;
V = mass_link4*g*b4;

%% Euler-Lagrange
Fb1 = sym(0);
Tt2 = sym(0);
Tt3 = sym(0);
Fb4 = sym(0);
L=T-V;

j = jacobian(diff(L,b1_dot),[b4,b1_dot,theta2_dot,theta3_dot,b4_dot]);
Fb1 = j(1)*b4_dot+j(2)*b1_ddot+j(3)*theta2_ddot+j(4)*theta3_ddot+j(5)*b4_ddot-diff(L,b1);

j = jacobian(diff(L,theta2_dot),[b4,b1_dot,theta2_dot,theta3_dot,b4_dot]);
Tt2 = j(1)*b4_dot+j(2)*b1_ddot+j(3)*theta2_ddot+j(4)*theta3_ddot+j(5)*b4_ddot-diff(L,theta2);

j = jacobian(diff(L,theta3_dot),[b4,b1_dot,theta2_dot,theta3_dot,b4_dot]);
Tt3 = j(1)*b4_dot+j(2)*b1_ddot+j(3)*theta2_ddot+j(4)*theta3_ddot+j(5)*b4_ddot-diff(L,theta3);

j = jacobian(diff(L,b4_dot),[b4,b1_dot,theta2_dot,theta3_dot,b4_dot]);
Fb4 = j(1)*b4_dot+j(2)*b1_ddot+j(3)*theta2_ddot+j(4)*theta3_ddot+j(5)*b4_ddot-diff(L,b4);

ForceandTorques = [Fb1;Tt2;Tt3;Fb4];
ForceandTorques = simplify(ForceandTorques);

matlabFunction(ForceandTorques,'File','OpenMan_torquesandforce');