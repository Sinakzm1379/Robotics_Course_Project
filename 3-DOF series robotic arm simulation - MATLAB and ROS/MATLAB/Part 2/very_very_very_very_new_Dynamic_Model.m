close all;
clear;
clc;

syms theta1 theta2 theta3 dtheta1 dtheta2 dtheta3 ddtheta1 ddtheta2 ddtheta3

m = 0.3;
c = [0.01; -0.005; 0.13];
I = [0.5, 1e-4, 4e-5; 1e-4, 0.2, 2e-4; 4e-5, 2e-4, 0.3];

% Define transformation matrices
T1 = [eye(3), [0;0;0]; [0,0,0,1]];
Tz_L1 = Tz(0.15);
Qz_theta1 = Qz(theta1);
TL1 = Tz_L1 * Qz_theta1;
T2 = T1 * Tz(0.3) * Qz(theta1) * Qx(-pi/2);
Tz_L2 = Tz(0.15);
Qz_theta2 = Qz(pi/2 + theta2);
TL2 = T2 * Tz_L2 * Qz_theta2;
T3 = T2 * Tz(0.3) * Qz(theta2) * Qx(-pi/2);
Tz_L3 = Tz(0.15);
Qz_theta3 = Qz(theta3);
TL3 = T3 * Tz_L3 * Qz_theta3;

% Define joint positions
j_1 = T1 * [0;0;0;1];
j_1 = j_1(1:3);
j_2 = T2 * [0;0;0;1];
j_2 = j_2(1:3);
j_3 = T3 * [0;0;0;1];
j_3 = j_3(1:3);

% Define vector r_ij
r_11 = TL1 * [c;1];
r_11 = r_11(1:3);
r_12 = TL2 * [c;1];
r_12 = r_12(1:3);
r_13 = TL3 * [c;1];
r_13 = r_13(1:3);
r_22 = r_12 - j_2;
r_23 = r_13 - j_2;
r_33 = r_13 - j_3;

% Define inertia tensors
I_1 = TL1(1:3,1:3) * (I - m * (TL1(1:3,4).' * TL1(1:3,4) * eye(3) - TL1(1:3,4) * TL1(1:3,4).')) / TL1(1:3,1:3);
I_2 = TL2(1:3,1:3) * (I - m * (TL2(1:3,4).' * TL2(1:3,4) * eye(3) - TL2(1:3,4) * TL2(1:3,4).')) / TL2(1:3,1:3);
I_3 = TL3(1:3,1:3) * (I - m * (TL3(1:3,4).' * TL3(1:3,4) * eye(3) - TL3(1:3,4) * TL3(1:3,4).')) / TL3(1:3,1:3);


e_1=T1(1:3,3);
e_2=T2(1:3,3);
e_3=T3(1:3,3);

v_1=[cross(e_1,r_11),zeros(3,1),zeros(3,1)]*[dtheta1;dtheta2;dtheta3];
v_2=[cross(e_1,r_12),cross(e_2,r_22),zeros(3,1)]*[dtheta1;dtheta2;dtheta3];
v_3=[cross(e_1,r_13),cross(e_2,r_23),cross(e_3,r_33)]*[dtheta1;dtheta2;dtheta3];
w_1=[e_1,zeros(3,1),zeros(3,1)]*[dtheta1;dtheta2;dtheta3];
w_2=[e_1,e_2,zeros(3,1)]*[dtheta1;dtheta2;dtheta3];
w_3=[e_1,e_2,e_3]*[dtheta1;dtheta2;dtheta3];

T=0;
V=0;
g=9.80665;
for i=1:3
    T=T+0.5*m*eval(['v_',num2str(i)]).'*eval(['v_',num2str(i)]);
    T=T+0.5*eval(['w_',num2str(i)]).'*eval(['I_',num2str(i)])*eval(['w_',num2str(i)]);
    V=V+m*g*eval(['r_1',num2str(i),'(3,1)']);
end

eqs=sym(zeros(3,1));
L=simplify(T-V);

j=jacobian(diff(L,dtheta1),[theta1,theta2,theta3,dtheta1,dtheta2,dtheta3]);
eqs(1)=j(1)*dtheta1+j(2)*dtheta2+j(3)*dtheta3+j(4)*ddtheta1+j(5)*ddtheta2+j(6)*ddtheta3-diff(L,theta1);

j=jacobian(diff(L,dtheta2),[theta1,theta2,theta3,dtheta1,dtheta2,dtheta3]);
eqs(2)=j(1)*dtheta1+j(2)*dtheta2+j(3)*dtheta3+j(4)*ddtheta1+j(5)*ddtheta2+j(6)*ddtheta3-diff(L,theta2);

j=jacobian(diff(L,dtheta3),[theta1,theta2,theta3,dtheta1,dtheta2,dtheta3]);
eqs(3)=j(1)*dtheta1+j(2)*dtheta2+j(3)*dtheta3+j(4)*ddtheta1+j(5)*ddtheta2+j(6)*ddtheta3-diff(L,theta3);

eqs=simplify(eqs);
matlabFunction(eqs,'File','Torques2');
