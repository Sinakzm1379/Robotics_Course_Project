function final = OpenMan_torques(b1,...
    theta2,theta3,b4,...
    b1_dot,theta2_dot,theta3_dot,...
    b4_dot,b1_ddot,theta2_ddot,...
    theta3_ddot,b4_ddot)

syms theta_dot theta b1 theta2 theta3 b4 ...
    b1_dot theta2_dot theta3_dot b4_dot ...
    b1_ddot theta2_ddot ...
    theta3_ddot b4_ddot real

%%
theta = [ b1 ; theta2 ; theta3 ; b4 ];
theta_dot = [ b1_dot ; theta2_dot; theta3_dot ; b4_dot];
theta_ddot = [ b1_ddot ; theta2_ddot; theta3_ddot ; b4_ddot];

tt = [-pi/2 theta2  theta3 0];
alpha = [-pi/2 pi/2 0 0];
%%
for i=1:4
    QQ{i} = [cos(tt(i)) -sin(tt(i))*cos(alpha(i)) sin(alpha(i))*sin(tt(i));
        sin(tt(i)) cos(alpha(i))*cos(tt(i)) -sin(alpha(i))*cos(tt(i));
        0 sin(alpha(i)) cos(alpha(i))];
end

Q0 = Qx(-pi/2);
Q1 = QQ{1};
Q2 = QQ{2};
Q3 = QQ{3};
Q4 = QQ{4};
%%
% all in WORLD frame
zero = [ 0 ; 0 ; 0];
z = [ 0 ; 0 ; 1];
e1 = Q0*z;
e2 = Q0*Q1*z ;
e3 = Q0*Q1*Q2*z ;
e4 = Q0*Q1*Q2*Q3*z ;

b1_0 = 0.08;
theta2_0 = 0;
theta3_0 = 0;
b4_0 = 0;

theta1_0 = theta1;
theta4_0 = theta4;

r11 = Q0*(com1_dh+[0;0;b1] );

r12 = Q0*(av1 + Q1*Qz( theta2 -theta2_0 )*(com2_dh) );
r22 = Q0*Q1*Qz( theta2 - theta2_0)*(com2_dh) ;

r13 = Q0*(av1 + Q1*av2 + Q1*Q2*Qz( theta3 - theta3_0)*(com3_dh) ) ;
r23 = Q0*(Q1*av2 + Q1*Q2*Qz( theta3 - theta3_0)*(com3_dh)) ;
r33 = Q0*(Q1*Q2*Qz( theta3 - theta3_0)*(com3_dh)) ;

r14 = Q0*(av1 + Q1*av2 + Q1*Q2*av3 + Q1*Q2*Q3*(com4_dh+[0;0;b4])) ;
r24 = Q0*(Q1*av2 + Q1*Q2*av3 + Q1*Q2*Q3*(com4_dh+[0;0;b4])) ;
r34 = Q0*(Q1*Q2*av3 + Q1*Q2*Q3*(com4_dh+[0;0;b4]) );
r44 = Q0*(Q1*Q2*Q3*(com4_dh+[0;0;b4]) ) ;

%%
% Ni in world frame
N1 = [e1 zero zero zero ];
N2 = [e1 cross(e2,r22) zero zero ];
N3 = [e1 cross(e2,r23) cross(e3,r33) zero ];
N4 = [e1 cross(e2,r24) cross(e3,r34) e4 ];

M1 = mass_link1 * N1'*N1 + W1'*I1_dh*W1;
M2 = mass_link2 * N2'*N2 + W2'*Qz(theta2 - theta2_0)*I2_dh*Qz(theta2 - theta2_0)'*W2;
M3 = mass_link3 * N3'*N3 + W3'*Qz(theta3 - theta3_0)*I3_dh*Qz(theta3 - theta3_0)'*W3;
M4 = mass_link4 * N4'*N4 + W4'*I4_dh*W4;

M = M1 + M2 + M3 + M4 ;

T = 0.5*theta_dot'*M*theta_dot;

%%
%hi all in world frame
h1 = (Q0*(com1_dh+[0;0;b1]) )'*z;
h2 = (Q0*(av1 + Q1*Qz(theta2 - theta2_0)*com2_dh ))'*z;
h3 = (Q0*(av1 + Q1*av2 + Q1*Q2*Qz(theta3 - theta3_0)*com3_dh ))'*z;
h4 = (Q0*(av1 + Q1*av2 + Q1*Q2*av3 + Q1*Q2*Q3*(com4_dh+[0;0;b4]) )'*z);

g = 9.81;
v1 = mass_link1 *g*h1;
v2 = mass_link2 *g*h2;
v3 = mass_link3 *g*h3;
v4 = mass_link4 *g*h4;

V = v1 + v2 + v3 + v4 ;

M_dot = M_dot_generator(M,theta,theta_dot);

n = M_dot*theta_dot ...
    -jacobian(T , theta)' + jacobian(V,theta)';

tav = (M*theta_ddot + n);

final = eval(tav);
end