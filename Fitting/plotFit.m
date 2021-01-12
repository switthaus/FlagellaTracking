function plotFit(t, coords, a, b, ome, phi)

for i = 1:size(coords{t}, 1)
x(i) = a(t)*cos(ome(t)*coords{t}(i, 3)+phi(t));
y(i) = b(t)*sin(ome(t)*coords{t}(i, 3)+phi(t));
end
scatter3(x, y, coords{t}(:, 3))
hold on
set(gca, 'DataAspectRatio', [1 1 1])
scatter3(coords{t}(:, 1), coords{t}(:, 2), coords{t}(:, 3))