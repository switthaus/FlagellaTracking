function MainTracking(dir, timepoints, dT, dXY, dZ)

%%
% Tracking Algorithm for Flagella using Cross-correlation
% Developed by Sven Witthaus and Toby Hess 2021/04/06
% Cross-correlating 2D flagellum at different z-levels
% Known problem in 2D correlation of inherent 3D flagella


%%


%Find Centroids
[centroids, MajorAxis, hysfin] = FindCentroids(dir, timepoints);

%Track flagella
[xoff, yoff, zoff, r0, cropped, ori, crosscorr] = Crosscorr_corr(hysfin, centroids, MajorAxis, timepoints);

xdisplacement = cell2mat(xoff); ydisplacement = cell2mat(yoff); zdisplacement = cell2mat(zoff);

%Find mean-square displacement
for i = 1:(timepoints-1)
    totdis(i) = sqrt(mean(sum(xdisplacement(1:i, :)*dXY).^2)+mean(sum(ydisplacement(1:i, :)*dXY).^2)+mean(sum(zdisplacement(1:i, :)*dZ).^2));
end
scatter(linspace(1, timepoints-1, timepoints-1)*dT, totdis)