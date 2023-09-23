clear all
clc
%% FKP
% D-H parametes
syms a1 a2 a3 a4 b1 b2 b3 b4 t1 t2 t3 t4 p1 p2 p3 p4 l1 l2 b0 
pi = sym(pi);
aa = [0 l1 l2 0];
bb = [b1 0 b0 b4];
tt = [pi/2 t2 t3 0];
pp = [pi/2 0 0 0];
% Rotation matrix
for i=1:4
    QQ{i} = [cos(tt(i)) -sin(tt(i))*cos(pp(i)) sin(pp(i))*sin(tt(i));
        sin(tt(i)) cos(pp(i))*cos(tt(i)) -sin(pp(i))*cos(tt(i));
        0 sin(pp(i)) cos(pp(i))];
end

Q = Qx(-pi/2)*Qz(-pi/2);
for i=1:4
    Q = Q*QQ{i};
end
% Rotation matrix
for i=1:4
    AA{i} = [aa(i)*cos(tt(i));
            aa(i)*sin(tt(i));
            bb(i)];
end
% transition+matrix
q = Qx(-pi/2)*Qz(-pi/2);
P = [0;0;0];
for i=1:4
    P = P + q*AA{i};
    q = q*QQ{i};
end
% Final Matrix
Q = simplify(Q);
P = simplify(P);
T = [Q P;[0 0 0] 1];
T = simplify(T)

%% IKP
% Known parametes
syms X0 Y0 Z0 Phi0
% equations
eqx = X0 == P(1);
eqy = Y0 == P(2);
eqz = Z0 == P(3);
eqphi = Phi0 == t2 + t3;
% solve equations
s = solve([eqx eqy eqz eqphi],[b1 t2 t3 b4]);
ansb1 = s.b1;
anst2 = s.t2;
anst3 = s.t3;
ansb4 = s.b4;