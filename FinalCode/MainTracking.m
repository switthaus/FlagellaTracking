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
Plot_centroids(hysfin, 100, 700, centroids, r0fin, xofffin, yofffin, zofffin, 36)

counter = 1;
counter=1;
for ii = 1:size(xoff, 2)
    if ii==any(badIDsfin) | all(xoff(:, ii)==0) | all(yoff(:, ii)==0) | all(zoff(:, ii)==0) | xoff(798, ii)==0 | yoff(798, ii)==0 | zoff(798, ii)==0
        continue
    end
    xofffin(:, counter) = xoff(:, ii);
    yofffin(:, counter) = yoff(:, ii);
    zofffin(:, counter) = zoff(:, ii);
    lengthfin(:, counter) = length(:, ii);
    orfin{counter} = or{ii};
    r0fin(counter, :) = r0(ii, :);
    counter=counter+1;
end

% Plot Useful figures: skellength, displacement (w and wo drift) and theta
% over time for flagella=id
% If id=0 use all flagella but the ones in excluded to plot the mean square
% displacement over time
id = 8;
arrfull = linspace(1, 63, 63);
excluded = setdiff(arrfull, 47); %here i exclude everything BUT flagella 47
drift = 8; % define flagella or set of flagella that just drift
PlotUseful(xofffin, yofffin, zofffin, lengthfin, orfin, 800, 8, excluded, drift)
