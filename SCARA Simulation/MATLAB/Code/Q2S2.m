clear all
clc
syms t0 t1 t2 t3 t4 t5 t6
pi = sym(pi);
tt = [t0 t1 t2 t3 t4 t5 t6];
pp = [0 pi/2 0 pi/2 -pi/2 pi/2 0];
aa = [0 0 270 90 0 0 0];
bb = [203 152 0 0 295 0 80];

for i=1:7
    QQ{i} = [cos(tt(i)) -sin(tt(i))*cos(pp(i)) sin(pp(i))*sin(tt(i));
        sin(tt(i)) cos(pp(i))*cos(tt(i)) -sin(pp(i))*cos(tt(i));
        0 sin(pp(i)) cos(pp(i))];
end

Q = [1 0 0;
    0 1 0;
    0 0 1];
for i=1:7
    Q = Q*QQ{i};
end

for i=1:7
    AA{i} = [aa(i)*cos(tt(i));
            aa(i)*sin(tt(i));
            bb(i)];
end

q = [1 0 0;
    0 1 0;
    0 0 1];
P = [0;0;0];
for i=1:7
    P = P + q*AA{i};
    q = q*QQ{i};
end

Q = simplify(Q);
P = simplify(P);