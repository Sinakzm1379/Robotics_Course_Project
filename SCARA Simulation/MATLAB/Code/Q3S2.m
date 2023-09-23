clear all
clc
syms t1 t2 t3 l1 l2 l3
% pi = sym(pi);
tt = [45 90 t3];
ll = [1 1 1];

r{1} = [ll(1)*cosd(tt(1)) + ll(2)*cosd(tt(1)+tt(2)) + ll(3)*cosd(tt(1)+tt(2)+tt(3));
        ll(1)*sind(tt(1)) + ll(2)*sind(tt(1)+tt(2)) + ll(3)*sind(tt(1)+tt(2)+tt(3))];
r{2} = [ll(2)*cosd(tt(1)+tt(2)) + ll(3)*cosd(tt(1)+tt(2)+tt(3));
        ll(2)*sind(tt(1)+tt(2)) + ll(3)*sind(tt(1)+tt(2)+tt(3))];
r{3} = [ll(3)*cosd(tt(1)+tt(2)+tt(3));
        ll(3)*sind(tt(1)+tt(2)+tt(3))];
E = [0 -1;
     1 0];
J = [1 1 1;
    E*r{1} E*r{2} E*r{3}];
J1 = inv(J);

symsumJ = 0;
symsumJ1 = 0;
for i=1:3
    for j=1:3
        symsumJ = symsumJ + J(i,j)^2;
        symsumJ1 = symsumJ1 + J1(i,j)^2;
    end
end

K = sqrt((1/3)*symsumJ)*sqrt((1/3)*symsumJ1);
q = 1/K;
q = simplify(q);
pretty(q)
fp = fplot(q,[0 180]);
title('\theta3 from 0^\circ to 180^\circ')
xlabel('\theta3');
ylabel('\delta(J)');
[mxMu,imx] = max(fp.YData);
tmax = fp.XData(imx);
mxMu
tmax