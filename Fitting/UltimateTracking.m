N = size(helix, 1);
X0 = zeros(N, 1);
Y0 = zeros(N, 1);
Z0 = zeros(N, 1);
or = zeros(N, 3);
a = zeros(N, 1);
b = zeros(N, 1);
ome = zeros(N, 1);
phi = zeros(N, 1);
coords = cell(N, 1);
beta = zeros(N, 1);
alpha = zeros(N, 1);
translation = zeros(N, 1);
z_trans = zeros(N, 1);
%Two subsequent flagella -> Corkscrew with raw data
%Plot how many flagella per z
%Filament movie
for i =1:N
    helixnew = imgaussfilt3(helix{i}, 1);
    [tri, hys] = hysteresis3d(helixnew, 0.35, 0.46, 26);
    [coords{i}, X0(i), Y0(i), Z0(i), or_1, a(i), b(i), ome(i), phi(i)] = getphase1(hys);
    or(i, :) = or_1;
    beta(i) = acos(dot(or(i, :), or(1, :))/(norm(or(i, :))*norm(or(1, :))));
    alpha(i) = (phi(i)-phi(1))/ome(i);
    z_trans(i) = Z0(i)-Z0(1)-alpha(i);
    translation(i) = sqrt((X0(i)-X0(1)).^2+(Y0(i)-Y0(1)).^2+(z_trans(i)).^2);
end