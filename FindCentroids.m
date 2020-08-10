function [centroids, MajorAxis, hysfin] = FindCentroids(dataFolder)

DIR = dataFolder;
%Make sure to not use dir twice
S = dir(fullfile(DIR, 'img_*.mat'));
timepoints = numel(S);
timepoints = 30;
Labels = cell(timepoints, 1);
s1 = cell(timepoints, 1);
hys = cell(timepoints, 1);
I_bg = cell(timepoints, 1);
hysfin = cell(timepoints, 1);

for k = 1:timepoints

    data = load(sprintf('img_T%03d.mat', k));
    I = data.Im_stack;
    I1 = zeros(2044, 2048, size(I, 1));
    hysfin{k} = cell(size(I, 1), 1);
    for i =1:size(I1, 3)  
        I_new = uint8(I{i}-50); %./double(bg);
        %mask = uint8(I_new>140 & I_new<250);
        I_try(:, :, i) = I_new;       
        %I1(:, :, i) = imgaussfilt(I_new{i}, 1.1);
    end
    % Smoothen the image
    I1 = imgaussfilt3(I_try, 1.1);
    clear I_try
    clear I_new
    %Threshold in 3D
    [tri, hys] = hysteresis3d(I1, 0.23, 0.28, 26);
    % Find Centroids and Orientations
    Labels = bwlabeln(hys);
    s1{k, 1} = regionprops3a(Labels,'Centroid', 'MajorAxis', 'MajorAxisLenght');
    
    for i =1:size(I1, 3)
        hysfin{k}{i} = sparse(double(hys(:, :, i)));
    end
    
    clear tri
    clear hys
    clear I1
    
end

centroids = cell(timepoints, 1);
MajorAxis = cell(timepoints, 1);


for i = 1:timepoints
    centroids{i} = {s1{i}.Centroid}';
    MajorAxis{i} = {s1{i}.MajorAxis}';
end

% Filter out Flagella that are too short
times_it_happened = zeros(timepoints, 1);
for k = 1:timepoints
    [l, m] = size(centroids{k});
    for ii = 1:l
        X_cen = round(centroids{k}{ii}(1)); Y_cen = round(centroids{k}{ii}(2)); Z_cen = round(centroids{k}{ii}(3));
        p = 15;
        lowlimit1 = Y_cen-p; lowlimit2 = X_cen-p; lowlimit3 = Z_cen-8;
        uplimit1 = Y_cen+p; uplimit2 = X_cen+p; uplimit3 = Z_cen+8;
        if lowlimit1 <= 0
            lowlimit1 = 1;
        end
        if lowlimit2 <= 0
            lowlimit2 = 1;
        end
        if uplimit1 >= 2045
            uplimit1 = 2044;
        end
        if uplimit2 >= 2045
            uplimit2 = 2044;
        end
        if uplimit3 >=30
            uplimit3 = 31;
        end
        if lowlimit3 <= 0
            lowlimit3 = 1;
        end
        
        cropped = zeros((uplimit1-lowlimit1+1), (uplimit2-lowlimit2+1), (uplimit3-lowlimit3+1));
        
        for jj=1:(uplimit3-lowlimit3+1)
            cropped(:, :, jj)= full(hysfin{k}{jj}(lowlimit1:uplimit1, lowlimit2:uplimit2));
        end
        %cropped = hysfin{k}(lowlimit1:uplimit1, lowlimit2:uplimit2, lowlimit3:uplimit3);
        if any(1==any(cropped(:, 1, :))) | any(1==any(1==cropped(:, end, :))) | any(1==any(1==cropped(1, :, :))) | any(1==any(1==cropped(end, :, :))) | any(1==any(1==cropped(:, :, 1))) | any(1==any(1==cropped(:, :, end)))
            continue    
            %satisfied = 1;
        else
            times_it_happened(k) = times_it_happened(k)+1;
            centroids{k}{ii} = [];
            MajorAxis{k}{ii} = [];
        end
    end
end


display(times_it_happened)