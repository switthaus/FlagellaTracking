function [coords, X0, Y0, Z0, or, a, b, ome, phi] = getphase1(I)

CC = bwconncomp(I);
Ids = CC.PixelIdxList;
for i = 1:size(Ids, 2)
    sizes(i) = size(Ids{i}, 1);
end
[value, arg] = max(sizes);
display(value)
[x, y, z] = ind2sub(size(I), Ids{arg});
xyz = [x, y, z];
fit = linefit3d(xyz);
or = [fit(2, 1)-fit(1, 1), fit(2, 2)-fit(1, 2), fit(2, 3)-fit(1, 3)];

centroid = or;
centroid = centroid/norm(centroid);
[~, theta, ~] = cart2sph(centroid(1), centroid(2), centroid(3));

k = cross([0, 0, 1], centroid);
k = k/norm(k);
K = [0, -k(3), k(2); k(3), 0, -k(1); -k(2), k(1), 0];
rot = pi/2-theta;
R = eye(3)+sin(rot)*K+(1-cos(rot))*K*K;

coords = zeros(size(x, 1), 3);

for ii = 1:size(x, 1)
    coords(ii, :) = R*[x(ii), y(ii), z(ii)].';
end

X0 = mean(coords(:, 1));
Y0 = mean(coords(:, 2));
Z0 = min(coords(:, 3));

coords(:, 1) = coords(:, 1)-X0;
coords(:, 2) = coords(:, 2)-Y0;
coords(:, 3) = coords(:, 3)-Z0;

[a, b, ome, phi] = fitElipHelix(coords(:, 1), coords(:, 2), coords(:, 3));
