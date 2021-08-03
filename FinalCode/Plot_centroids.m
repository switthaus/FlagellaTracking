function Plot_crosscorr(hysfin, start, timepoints, centroids, r01, xoffs, yoffs, zoffs, id)
figure
r0 = r01;
%r0(:, 1) = r01(:, 2);
%r0(:, 2) = r01(:, 1);
for j=1:31
    hys_test(:, :, j) = full(hysfin{start}{j});
end
ptest = cell(timepoints, 1);
%closestIndex = 221;
data = load(sprintf('img_T%03i.mat', start));
dx = 0.1625 ;dy=0.1625; dz = 0.3;
I = data.Im_stack;
[y, x, z] = size(I);
%[x, y, z] = size(I);
[X, Y, Z] = meshgrid(1:x, 1:y, 1:z);
r0testx = r0(id, 1)+sum(xoffs(1:(start), id));
r0testy = r0(id, 2)+sum(yoffs(1:(start), id));

xlim([(round(r0testx-100)), (round(r0testx+100))])
ylim([(round(r0testy-100)), (round(r0testy+100))])
Xcropped = X((round(r0testy-100)):(round(r0testy+100)), (round(r0testx-100)):(round(r0testx+100)), (round(r0(id, 3))-5):(round(r0(id, 3))+5));
Ycropped = Y((round(r0testy-100)):(round(r0testy+100)), (round(r0testx-100)):(round(r0testx+100)), (round(r0(id, 3))-5):(round(r0(id, 3))+5));
Zcropped = Z((round(r0testy-100)):(round(r0testy+100)), (round(r0testx-100)):(round(r0testx+100)), (round(r0(id, 3))-5):(round(r0(id, 3))+5));
hyscropped = I((round(r0testy-100)):(round(r0testy+100)), (round(r0testx-100)):(round(r0testx+100)), (round(r0(id, 3))-5):(round(r0(id, 3))+5));
surf1=isosurface(Xcropped,Ycropped, Zcropped,hyscropped,195);
%p1 = patch(surf1);
ptest{1} = patch(surf1);
isonormals(Xcropped,Ycropped,Zcropped,hyscropped,ptest{1});

set(ptest{1},'FaceColor','red','EdgeColor','none', 'FaceAlpha', 0.15); % set the color, mesh and transparency level of the surface
daspect([1,1,1])
view(3); axis tight
camlight; lighting gouraud
X_cen_old = r0testx; Y_cen_old=r0testy; Z_cen_old=r0(id, 3);
counter = 2;
for kk = (start+1):(timepoints-1)
    title(sprintf('%01i Frame', kk))
    data = load(sprintf('img_T%03i.mat', kk));
    Ik = data.Im_stack;
    for j=1:31
        hys_test(:, :, j) = full(hysfin{kk}{j});
    end
    hyscroppednew = Ik((round(r0(id, 2))-100):(round(r0(id, 2))+100), (round(r0(id, 1))-100):(round(r0(id, 1))+100), (round(r0(id, 3))-5):(round(r0(id, 3))+5));
    surf2=isosurface(Xcropped, Ycropped, Zcropped, hyscroppednew,195);
    ptest{counter} = patch(surf2);
    %p2 = patch(surf2);
    isonormals(Xcropped,Ycropped,Zcropped,hyscroppednew,ptest{kk});
    if ~rem(kk, 2)
        set(ptest{counter},'EdgeColor','none', 'Facecolor', 'blue', 'FaceAlpha', 0.15);
    else
        set(ptest{counter},'EdgeColor','none', 'Facecolor', 'red', 'FaceAlpha', 0.15);
    end

    hold on
    xlim([(round(r0(id, 1))-100), (round(r0(id, 1))+100)])
    ylim([(round(r0(id, 2))-100), (round(r0(id, 2))+100)])
    newxcen = r0(id, 1)+sum(xoffs(1:(kk-1), id));
    newycen = r0(id, 2)+sum(yoffs(1:(kk-1), id));
    newzcen = r0(id, 3)+sum(zoffs(1:(kk-1), id));
    %vectors = FindActualOrientation(centroids, MajorAxis, id);
    quiverplot = quiver3(X_cen_old, Y_cen_old, Z_cen_old, xoffs(kk-1, id), yoffs(kk-1, id), zoffs(kk-1, id), 'AutoScale','off', 'linewidth', 3);
    scatterplot = scatter3(X_cen_old, Y_cen_old, Z_cen_old, 'MarkerFaceColor', 'k');
    scatterplot1 = scatter3(newxcen, newycen, newzcen, 'green', 'filled');
    %quiver3(newxcen, newycen, newzcen, vectors(idx_or, 1)*5, vectors(idx_or, 2)*5, vectors(idx_or, 3)*5)
    pause(1)
    delete(ptest{counter-1})
    delete(quiverplot)
    delete(scatterplot)
    delete(scatterplot1)
    X_cen_old=newxcen;
    Y_cen_old=newycen;
    Z_cen_old=newzcen;
    counter = counter+1;
end
%quiver3(centroids_plot(1:(end-1), 1, 1)*dx, centroids_plot(1:(end-1), 2, 1)*dy, centroids_plot(1:(end-1), 3, 1)*dz, x_offset{2}'*dx, y_offset{2}'*dy, z_offset{2}', 'AutoScale','off')
close(figure)