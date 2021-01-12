function [a, b, ome, phi] = fitElipHelix(x, y, z)

w = optimvar('w', 2);

a = sum(x.*cos(w(1).*z+w(2)))/sum(cos(w(1).*z+w(2)).^2);
b = sum(y.*sin(w(1).*z+w(2)))/sum(sin(w(1).*z+w(2)).^2);

eq1 = sum((x-a.*cos(w(1).*z+w(2))).*(z*a.*sin(w(1).*z+w(2)))-(y-b.*sin(w(1).*z+w(2))).*(z*b.*cos(w(1).*z+w(2)))) == 0;
eq2 = sum((x-a.*cos(w(1).*z+w(2))).*(a.*sin(w(1).*z+w(2)))-(y-b.*sin(w(1).*z+w(2))).*(b.*cos(w(1).*z+w(2)))) == 0;

prob = eqnproblem;
prob.Equations.eq1 = eq1;
prob.Equations.eq2 = eq2;
% pitch of flagella: 1.36um
w0.w = [0.28 3*pi/2];
[sol,fval,exitflag] = solve(prob,w0);
ome = sol.w(1);
phi = sol.w(2);

a = sum(x.*cos(ome*z+phi))/sum(cos(ome*z+phi).^2);
b = sum(y.*sin(ome*z+phi))/sum(sin(ome*z+phi).^2);