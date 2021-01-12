    
%I = imread('img_T001.tif');
data = load('img_T001.mat');
I = data.Im_stack;
z = size(I, 1);
[y, x] = size(I{1});
%[x, y, z] = size(I);
[X, Y, Z] = meshgrid(1:x, 1:y, 1:z);

dx = 0.1625 ;dy=0.1625; dz = 0.3;

X = X*dx;
Y = Y*dy;
Z = Z*dz;

centroids_unpackaged = centroids{2};

%vectors = zeros(l, p);
%centroids_plot = zeros(l, p);
centroids_plot = cell2mat(centroids{2, 1});
vectors = cell2mat(MajorAxis{2, 1});
[l, p] = size(vectors);

for i = 1:(l-1)
    for j = 1:3
        
        v = vectors(i, :);
        if abs(norm(v)-1)>0.0001
            fprintf(...
                'Problem at i = %i, j= %i\n',...
                i,j);
            return;
        end
        %transform the z component of the 
        %orientation vector to reflect the
        %different scale along the z axis
        %formula: v_z_new = cos(gamma) = 
        % cos(atan(dz/dx/v_z_old))
        sina = sqrt(1-v(3)^2);
        cosb = 1/sqrt(1+...
            (dz/dx/v(3))^2);
        sinb = sqrt(1-cosb^2);
        vectors(i,1) = v(1);%/sina*sinb;
        vectors(i,2) = v(2);%/sina*sinb;
        vectors(i,3) = v(3);%cosb;
        
        if isempty(centroids_unpackaged{i})
            continue
        end
                
        %centroids_plot(i, j) = ...
        %    centroids_unpackaged{i}(1, j);
    end
end


figure
h = quiver3(centroids_plot(:, 1)*dx, ...
    centroids_plot(:, 2)*dy, ...
    centroids_plot(:, 3)*dz, 5*vectors(:, 1), ...
    5*vectors(:, 2), 5*vectors(:, 3), ...
    'AutoScale','off');
    
hold on
set(gca,'DataAspectRatio', [1 1 1]); 
%set(gca, 'XLim', [115, 125])
%set(gca, 'YLim', [75, 80])
%set(gca, 'ZLim', [2, 6])
scatter3(centroids_plot(:, 1)*dx,...
    centroids_plot(:, 2)*dy, ...
    centroids_plot(:, 3)*dz)
%isosurface(X, Y, Z, I, 300)
for i = 1:size(hysfin{2}, 1)
    hys(:, :, i) = full(hysfin{2}{i});
end

isosurface(X, Y, Z, hys, 0.5);
hold off