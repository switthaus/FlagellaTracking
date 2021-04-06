function [Xr, Yr, Zr] = getIndices(X, Y, Z, hys, first)

for i = 1:31
hys_test(:, :, i) = full(hys{first}{i});
end

isosurface(X(500:1500, 500:1500, 15:24), Y(500:1500, 500:1500, 15:24), Z(500:1500, 500:1500, 15:24), hys_test(500:1500, 500:1500, 15:24), 0.5)
set(gca, 'DataAspectRatio', [1 1 1])
view(0,90)
[x,y] = getpts;

Xr = round(x);
Yr = round(y);
Zr = 20*ones(size(Xr));