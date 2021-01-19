function idx = findclosestcentroid(X_cen, Y_cen, Z_cen, centroids, t)

for ii = 1:size(centroids{t}, 1)
    if isempty(centroids{t}{ii})
        centroids{t}{ii} = [0, 0, 0];
    end
end
centroids_tot = cell2mat(centroids{t});

distances = sqrt(sum(bsxfun(@minus, centroids_tot, [X_cen, Y_cen, Z_cen]).^2,2));
%find the smallest distance and use that as an index into B:
idx = find(distances==min(distances));