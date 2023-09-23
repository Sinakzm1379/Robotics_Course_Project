clear all
clc

% DATA
syms t0 t1 t2 t3 t4 t5 t6
pi = sym(pi);
tt = [t1 t2 t3 t4 t5 t6];
pp = [pi/2 0 pi/2 -pi/2 pi/2 0];
aa = [0 270 90 0 0 0];
bb = [355 0 0 295 0 80];

% MARIX
for i=1:6
    QQ{i} = [cos(tt(i)) -sin(tt(i))*cos(pp(i)) sin(pp(i))*sin(tt(i));
        sin(tt(i)) cos(pp(i))*cos(tt(i)) -sin(pp(i))*cos(tt(i));
        0 sin(pp(i)) cos(pp(i))];
end
Q = [1 0 0;
    0 1 0;
    0 0 1];
for i=1:6
    Q = Q*QQ{i};
end
for i=1:6
    a{i} = [aa(i)*cos(tt(i));
            aa(i)*sin(tt(i));
            bb(i)];
end
q = [1 0 0;
    0 1 0;
    0 0 1];
P = [0;0;0];
for i=1:6
    P = P + q*a{i};
    q = q*QQ{i};
end
for i=1:6
    b{i} = [aa(i);
        bb(i)*sin(pp(i));
        bb(i)*cos(pp(i))];
end
for i=1:6
    u{i} = [sin(pp(i)*sin(tt(i)));
        -sin(pp(i))*cos(tt(i));
        cos(pp(i))];
end
C = P-Q*b{6};
R = QQ{4}*QQ{5}*QQ{6};

% The coefficients of Eq
% u sin pp
% landa cos pp
A = 2*aa(1)*C(1);
B = 2*aa(1)*C(2);
Cc = 2*aa(2)*aa(3) - 2*bb(2)*bb(4)*sin(pp(2))*sin(pp(3));
D = 2*aa(3)*bb(2)*sin(pp(2)) + 2*aa(2)*bb(4)*sin(pp(3));
E = aa(2)^2+aa(3)^2+bb(2)^2+bb(3)^2+bb(4)^2-aa(1)^2-C(1)^2-C(2)^2-(C(3)-bb(1))^2;
F = C(2)*sin(pp(1));
G = -C(1)*sin(pp(1));
H = -bb(4)*sin(pp(2))*sin(pp(3));
I = aa(3)*sin(pp(2));
J = bb(2) + bb(3)*sin(pp(2)) + bb(4)*sin(pp(2))*sin(pp(3)) - (C(3)-bb(1))*sin(pp(1));
K = 4*aa(1)^2*H^2+sin(pp(1))^2*Cc^2;
L = 4*aa(1)^2*I^2+sin(pp(1))^2*D^2;
M = 2*(4*aa(1)^2*H*I + sin(pp(1))^2*Cc*D);
N = 2*(4*aa(1)^2*H*J + sin(pp(1))^2*Cc*E);
Pp = 2*(4*aa(1)^2*I*J + sin(pp(1))^2*D*E);
Qq = 4*aa(1)^2*J^2 + sin(pp(1))^2*E^2 - 4*aa(1)^2*sin(pp(1))^2*(C(1)^2+C(2)^2)^2;
W = -sin(pp(4))*(R(2,2)*sin(pp(6))+R(2,3)*cos(pp(6)));
X = sin(pp(4))*(R(1,2)*sin(pp(6))+R(1,3)*cos(pp(6)));
Y = -cos(pp(4))*(R(3,2)*sin(pp(6))+R(3,3)*cos(pp(6)))+cos(pp(5));

% Position Eq
eq1 = QQ{2}*(b{2}+QQ{3}+bb(4)*u{3})==(transpose(QQ{1}))*C-b{1};
eq2 = A*cos(tt(1))+B*sin(tt(1))+Cc*cos(tt(3))+D*sin(tt(3))+E == 0;
eq3 = F*cos(tt(1))+G*sin(tt(1))+H*cos(tt(3))+I*sin(tt(3))+J == 0;
eq4 = K*cos(tt(3))^2+L*sin(tt(3))^2+M*cos(tt(3))*sin(tt(3))+N*cos(tt(3))+Pp*sin(tt(3))+Qq == 0;

% Rotation Eq
eq5 = W*cos(tt(4))+X*sin(tt(4)) == Y;
eq6 = cos(tt(6)) == (R(1,1)*sin(pp(4))*sin(tt(4))-R(2,2)*sin(pp(4))*cos(tt(4))+R(3,2)*cos(pp(4))-cos(pp(4))*sin(pp(6)))/(sin(pp(5))*cos(pp(6)));
eq7 = cos(tt(5)) == (cos(tt(4))*cos(pp(5))-R(3,2)*sin(pp(6))-R(3,3)*cos(pp(6)))/(sin(pp(4))*sin(pp(5)));
