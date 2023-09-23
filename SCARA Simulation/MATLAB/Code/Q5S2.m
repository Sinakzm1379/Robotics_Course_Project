clear all
clc
syms t1 t2 t3 l1 l2  b
J = [1 1 1 0;
    -(l1*sin(t1)+l2*sin(t2+t1)) -(l2*sin(t2+t1)) 0 0;
    (l1*cos(t1)+l2*cos(t2+t1)) (l2*cos(t2+t1)) 0 0;
    0 0 0 1];
detJ = det(J);
detJ = simplify(detJ)