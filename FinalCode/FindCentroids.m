function [centroids, MajorAxis, hysfin] = FindCentroids(dataFolder, timepoints)
% Allocate cells
DIR = dataFolder;
%Make sure to not use dir twice
S = dir(fullfile(DIR, 'img_*.mat'));
Labels = cell(timepoints, 1);
s1 = cell(timepoints, 1);
hys = cell(timepoints, 1);
I_bg = cell(timepoints, 1);
hysfin = cell(timepoints, 1);

%Threshold the image and find centroids using regionprops
for k = 1:timepoints
    
    data = load(sprintf('img_T%03d.mat', k));
    I = data.Im_stack;
    bg = mean(I, 3);
    bgfilt = imgaussfilt(bg, 40);
    I1 = I./bgfilt;
    hysfin{k} = cell(size(I, 3), 1);
    % Smoothen the image
    I2 = imgaussfilt3(uint8(I1*100), 1.1);
    %Threshold in 3D
    [hys] = SparseHysteresis(I2, 0.15, 0.2);
    display('Finished Thresholding')
    hysfinal = zeros(size(I2));
    for i =1:size(hys, 1)
        hysfinal(:, :, i) = hys{i}(:, :);
    end
    %[tri, hys] = hysteresis3d(I1, 0.23, 0.28, 26);
    % Find Centroids and Orientations
    Labels = bwlabeln(hysfinal);
    s1{k, 1} = regionprops3a(Labels,'Centroid', 'MajorAxis', 'MajorAxisLenght');
    
    for i =1:size(I1, 3)
        hysfin{k}{i} = sparse(double(hysfinal(:, :, i)));
    end

    clear hys
    clear I1
    fprintf('Finished frame number %.01d\n', k)
end

centroids = cell(timepoints, 1);
MajorAxis = cell(timepoints, 1);


for i = 1:timepoints
    centroids{i} = {s1{i}.Centroid}';
    MajorAxis{i} = {s1{i}.MajorAxis}';
end

% Filter out Flagella that are too short
times_it_happened = zeros(timepoints, 1);
k=1
[l, m] = size(centroids{k});
for ii = 1:l
        X_cen = round(centroids{k}{ii}(1)); Y_cen = round(centroids{k}{ii}(2)); Z_cen = round(centroids{k}{ii}(3));
        p = 15;
        lowlimit1 = Y_cen-p; lowlimit2 = X_cen-p; lowlimit3 = Z_cen-4;
        uplimit1 = Y_cen+p; uplimit2 = X_cen+p; uplimit3 = Z_cen+4;
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
        if X_cen>2040 | Y_cen>2040 | X_cen<4 | Y_cen<4
            display('happened')
            continue
        end
        croppedtemp = CropFlagellum_labelsBW(X_cen, Y_cen, round(Z_cen), hysfin{k});
        %display(size(croppedtemp))
        length = skellengthBW(croppedtemp);
        %display(length(1))
        if length(1)>15
            continue
        %if sum(croppedtemp, 'all')>100
        %    continue
        %if any(1==any(cropped(:, 1, :))) | any(1==any(1==cropped(:, end, :))) | any(1==any(1==cropped(1, :, :))) | any(1==any(1==cropped(end, :, :))) | any(1==any(1==cropped(:, :, 1))) | any(1==any(1==cropped(:, :, end)))
        %    continue    
            %satisfied = 1;
        else
            times_it_happened(k) = times_it_happened(k)+1;
            centroids{k}{ii} = [];
            MajorAxis{k}{ii} = [];
        end
end


display(times_it_happened)