function Plot_crosscorr(hysfin, start, timepoints, centroids, r01, xoff, yoff, zoff, id)
figure
r0 = r01;
%r0(:, 1) = r01(:, 2);
%r0(:, 2) = r01(:, 1);
for j=1:31
    hys_test(:, :, j) = full(hysfin{1}{j});
end
ptest = cell(timepoints, 1);
%closestIndex = 221;
data = load('img_T001.mat');
dx = 0.1625 ;dy=0.1625; dz = 0.3;
I = data.Im_stack;
z = size(I, 1);
[y, x] = size(I{1});
%[x, y, z] = size(I);
[X, Y, Z] = meshgrid(1:x, 1:y, 1:z);
xlim([(round(r0(id, 1))-100), (round(r0(id, 1))+100)])
ylim([(round(r0(id, 2))-100), (round(r0(id, 2))+100)])
Xcropped = X((round(r0(id, 2))-100):(round(r0(id, 2))+100), (round(r0(id, 1))-100):(round(r0(id, 1))+100), (round(r0(id, 3))-5):(round(r0(id, 3))+5));
Ycropped = Y((round(r0(id, 2))-100):(round(r0(id, 2))+100), (round(r0(id, 1))-100):(round(r0(id, 1))+100), (round(r0(id, 3))-5):(round(r0(id, 3))+5));
Zcropped = Z((round(r0(id, 2))-100):(round(r0(id, 2))+100), (round(r0(id, 1))-100):(round(r0(id, 1))+100), (round(r0(id, 3))-5):(round(r0(id, 3))+5));
hyscropped = hys_test((round(r0(id, 2))-100):(round(r0(id, 2))+100), (round(r0(id, 1))-100):(round(r0(id, 1))+100), (round(r0(id, 3))-5):(round(r0(id, 3))+5));
surf1=isosurface(Xcropped,Ycropped, Zcropped,hyscropped,0.5);
%p1 = patch(surf1);
ptest{1} = patch(surf1);
isonormals(Xcropped,Ycropped,Zcropped,hyscropped,ptest{1});

set(ptest{1},'FaceColor','red','EdgeColor','none', 'FaceAlpha', 0.15); % set the color, mesh and transparency level of the surface
daspect([1,1,1])
view(3); axis tight
camlight; lighting gouraud

for kk = 2:(timepoints-1)
    for j=1:31
        hys_test(:, :, j) = full(hysfin{kk}{j});
    end
    hyscroppednew = hys_test((round(r0(id, 2))-100):(round(r0(id, 2))+100), (round(r0(id, 1))-100):(round(r0(id, 1))+100), (round(r0(id, 3))-5):(round(r0(id, 3))+5));
    surf2=isosurface(Xcropped, Ycropped, Zcropped, hyscroppednew,0.5);
    ptest{kk} = patch(surf2);
    %p2 = patch(surf2);
    isonormals(Xcropped,Ycropped,Zcropped,hyscroppednew,ptest{kk});
    if ~rem(kk, 2)
        set(ptest{kk},'EdgeColor','none', 'Facecolor', 'blue', 'FaceAlpha', 0.15);
    else
        set(ptest{kk},'EdgeColor','none', 'Facecolor', 'red', 'FaceAlpha', 0.15);
    end

    hold on
    xlim([(round(r0(id, 1))-100), (round(r0(id, 1))+100)])
    ylim([(round(r0(id, 2))-100), (round(r0(id, 2))+100)])
    x_displacement = cell2mat(xoff);
    y_displacement = cell2mat(yoff);
    z_displacement = cell2mat(zoff);
    newxcen = r0(id, 1)+sum(x_displacement(1:(kk-2), id));
    newycen = r0(id, 2)+sum(y_displacement(1:(kk-2), id));
    newzcen = r0(id, 3)+sum(z_displacement(1:(kk-2), id));
    %vectors = FindActualOrientation(centroids, MajorAxis, id);
    quiverplot = quiver3(newxcen, newycen, newzcen, xoff{kk-1}(id), yoff{kk-1}(id), zoff{kk-1}(id), 'AutoScale','off', 'linewidth', 3);
    scatterplot = scatter3(newxcen, newycen, newzcen, 'filled');
    %quiver3(newxcen, newycen, newzcen, vectors(idx_or, 1)*5, vectors(idx_or, 2)*5, vectors(idx_or, 3)*5)
    pause(1)
    delete(ptest{kk-1})
    delete(quiverplot)
    delete(scatterplot)
end
%quiver3(centroids_plot(1:(end-1), 1, 1)*dx, centroids_plot(1:(end-1), 2, 1)*dy, centroids_plot(1:(end-1), 3, 1)*dz, x_offset{2}'*dx, y_offset{2}'*dy, z_offset{2}', 'AutoScale','off')
close(figure)