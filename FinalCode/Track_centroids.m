function [xoffcen, yoffcen, zoffcen, r0, cropped, template, or, length, badIDs] = Track_centroids(hys, centroids, timepoints)

% Crosscorrelation code: Choose a flagella and get its centroid. Next, find 
% its cropped picture, and then crosscorrelate this into the next frame. 
% To get how much it has been displaced in z, crosscorrelate it to all
% other frames in z as well. By getting the value of the crosscorrelation,
% we can fit a parabola and get exactly how much it was displaced in z.
% From this, we can infer where the flagellum is now and find its closest
% centroid (in the new frame). 

data = load('img_T001.mat');
I = data.Im_stack;
[y, x, z] = size(I);
%[x, y, z] = size(I);

cropped = cell(timepoints, 1);
croppedimfull = cell(timepoints, 1);
template = cell(timepoints, 1);

% Remove all centroids rows that are empty
counter=1;
for i=1:size(centroids{1}, 1)
    if isempty(centroids{1}{i, :})
        continue
    else
        r0(counter, :) = centroids{1}{i, :};
    end
    counter=counter+1;
end


X_cen = r0(:, 1); Y_cen = r0(:, 2); Z_cen=r0(:, 3);
xoffcen = zeros(timepoints-1, size(r0, 1)); yoffcen = zeros(size(xoffcen)); zoffcen = zeros(size(xoffcen));
for i = 1:timepoints
    cropped{i} = cell(size(X_cen));
    template{i} = cell(size(X_cen));
end
X_cen_old=X_cen; Y_cen_old=Y_cen; Z_cen_old=Z_cen;

%Remove flagella where centroids are far out
badIDs = find(r0(:, 1)<200)';
badIDs = [badIDs, find(r0(:, 1)>1800)'];
badIDs = [badIDs, find(r0(:, 2)>1800)'];
badIDs = [badIDs, find(r0(:, 2)<200)'];
display(size(unique(badIDs)))

for kk = 2:(timepoints-1)
    counter = 1;
    Ihelp = load(sprintf('img_T%03d.mat', kk));
    images = Ihelp.Im_stack;
    for ii = 1:size(X_cen, 1)
        %Not continue if this ID is bad
        if any(badIDs==ii)
            continue
        else
         
            %Find closest centroid to last [X_cen, Y_cen, Z_cen] triplet
            idx = findclosestcentroid(X_cen(ii), Y_cen(ii), Z_cen(ii), centroids, kk);
            X_cen(ii) = centroids{kk}{idx, :}(1); Y_cen(ii)=centroids{kk}{idx, :}(2); Z_cen(ii)=centroids{kk}{idx, :}(3);
            
            % Prune if center is too far out
            if X_cen(ii)<100 | X_cen(ii)>2000 | Y_cen(ii)< 100 | Y_cen(ii)>2000
                badIDs = [badIDs, ii];
                continue
            else
                % Find track by subtracting current centroid from last
                % centroid
                xoffcen(kk-1, ii) = X_cen(ii)-X_cen_old(ii);
                yoffcen(kk-1, ii) = Y_cen(ii)-Y_cen_old(ii);
                zoffcen(kk-1, ii) = Z_cen(ii)-Z_cen_old(ii);
                
                % Find how the cropped Flagella looks like using labeling
                [croppedtemp, croppedim, p] = CropFlagellum_labels(round(X_cen(ii)), round(Y_cen(ii)), round(Z_cen(ii)), hys{kk}, images); 
                
                % If flagella could not be found or has only one index in
                % z, no longer track it.
                if croppedtemp == 0 | size(croppedim, 3)==1
                    display(sprintf('failure at t=%01i and centroid %01i', [kk ii]))
                    badIDs = [badIDs, ii];
                else
                    % Save relevant quantities
                    cropped{kk}{ii} = croppedtemp;
                    template{kk}{ii} = croppedim;
                    or{ii}(kk-1, :) = getOrientation(croppedtemp, croppedim);
                    le = skellength(croppedim);
                    length(kk, ii) = le(1);
                    %Orientation{kk, counter} = MajorAxis{kk}(idx);
                    counter = counter+1;
                    X_cen_old(ii) = X_cen(ii);
                    Y_cen_old(ii) = Y_cen(ii);
                    Z_cen_old(ii) = Z_cen(ii);
                end
            end
        end
    end
    display(sprintf('Finished frame %01i', kk))
end



