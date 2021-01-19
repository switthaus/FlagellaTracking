function [xoffset_fin, yoffset_fin, zoffset_fin, r0, cropped, Orientation, crosscorr] = Crosscorr_corr(hys, centroids, MajorAxis)

% Crosscorrelation code: Choose a flagella and get its centroid. Next, find 
% its cropped picture, and then crosscorrelate this into the next frame. 
% To get how much it has been displaced in z, crosscorrelate it to all
% other frames in z as well. By getting the value of the crosscorrelation,
% we can fit a parabola and get exactly how much it was displaced in z.
% From this, we can infer where the flagellum is now and find its closest
% centroid (in the new frame). 

data = load('img_T001.mat');
I = data.Im_stack;
z = size(I, 1);
[y, x] = size(I{1});
%[x, y, z] = size(I);
[X, Y, Z] = meshgrid(1:x, 1:y, 1:z);

dx = 0.1625 ;dy=0.1625; dz = 0.3;

timepoints = 2;%numel(centroids);
times_it_happened = zeros(timepoints, 1);
images = cell(timepoints, 1);
y_offset = cell(timepoints, 1);
x_offset = cell(timepoints, 1);
z_offset = cell(timepoints, 1);
cropped = cell(timepoints, 1);

for kk = 1:timepoints
    Ihelp = load(sprintf('img_T%03d.mat', kk));
    images{kk} = Ihelp.Im_stack;
end


%Find Closest Centroid

%[minValue,closestIndex] = min(abs(X_cen-centroids_real(:, 1)));
closestIndex = 221;
r0 = [centroids{1}{closestIndex, 1}(1)*dx, centroids{1}{closestIndex, 1}(2)*dy, centroids{1}{closestIndex, 1}(3)*dz];
X_cen = r0(1);
Y_cen = r0(2);
Z_cen = r0(3);

Xr_cen = round(X_cen);
Yr_cen = round(Y_cen);
Zr_cen = round(Z_cen);



for kk = 1:(timepoints-1)
    counter = 1;
    for ii = 1:size(X_cen, 2)
        % Find location of Flagella at timeframe = kk
        if kk>1
            xhistory = cell2mat(x_offset(kk-1));
            yhistory = cell2mat(y_offset(kk-1));
            zhistory = cell2mat(z_offset(kk-1));
            X_cen(ii) = X_cen(ii) + xhistory(end, ii);
            Y_cen(ii) = Y_cen(ii) + yhistory(end, ii);
            Z_cen(ii) = Z_cen(ii) + zhistory(end, ii);
            Xr_cen(ii) = round(X_cen(ii));
            Yr_cen(ii) = round(Y_cen(ii));
            Zr_cen(ii) = round(Z_cen(ii));
        else
            Xr_cen(ii) = round(X_cen(ii));
            Yr_cen(ii) = round(Y_cen(ii));
            Zr_cen(ii) = round(Z_cen(ii));
        end
        idx = findclosestcentroid(X_cen(ii), Y_cen(ii), Z_cen(ii), centroids, kk);
        %display(MajorAxis{kk}{idx})
        Orientation{kk, counter} = MajorAxis{kk}(idx);
        p1 = 10; p2 = 10; p3 = 10; p4 = 10; satisfied = 0;
        % Increase search area until flagella fully inside
        while ~ satisfied
            lowlimit1 = Yr_cen(ii)-p4; lowlimit2 = Xr_cen(ii)-p1;
            uplimit1 = Yr_cen(ii)+p3; uplimit2 = Xr_cen(ii)+p2;
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
            % Save cropped image and BW image
            cropped{kk} = full(hys{kk}{Zr_cen(ii)}(lowlimit1:uplimit1, lowlimit2:uplimit2));
            croppedim = images{kk}{Zr_cen(ii)}(lowlimit1:uplimit1, lowlimit2:uplimit2);
            if isempty(cropped{kk})
                display('Flagella out of frame')
            end
            
            if lowlimit1==1 | lowlimit2==1 | uplimit1==512 | uplimit2 == 512
                times_it_happened(kk) = times_it_happened(kk)+1;
                satisfied = 1;
            end
            if any(1==cropped{kk}(:, 1, 1))
                p1 = p1+1;
                continue
            end
            if any(1==cropped{kk}(:, end, 1))
                p2 = p2+1;
                continue
            end
            if any(1==cropped{kk}(1, :, 1))
                p4 = p4+1;
                continue
            end
            if any(1==cropped{kk}(end, :, 1))
                p3 = p3+1;
                continue
            end
            
            satisfied = 1;
            
        end
        
        %Create search area (bigger box) for next frame
        lowlimit_new1 = Yr_cen(ii)-p4-50; lowlimit_new2 = Xr_cen(ii)-p1-50;
        uplimit_new1 = Yr_cen(ii)+p3+50; uplimit_new2 = Xr_cen(ii)+p2+50;
        
        if lowlimit_new1 <= 0
           lowlimit_new1 = 1;
        end
        if lowlimit_new2 <= 0
           lowlimit_new2 = 1;
        end
        if uplimit_new1 >= 2045
           uplimit_new1 = 2044;
        end
        if uplimit_new2 >= 2045
           uplimit_new2 = 2044;
        end
        
        % Indices are weird! Find offsets in frame kk and kk+1 in same
        % coordinate system. By subtracting offsets obtain displacement.
        
        croppedhelp = images{kk}{Zr_cen(ii)}(lowlimit_new1:uplimit_new1, lowlimit_new2:uplimit_new2);
        maxima = zeros(7, 1);
        Zr_newcen_lower = Zr_cen(ii)-5; Zr_newcen_upper = Zr_cen(ii)+5;
        if Zr_newcen_lower < 1
            Zr_newcen_lower = 1;
        end
        if Zr_newcen_upper > 31
            Zr_newcen_upper = 31;
        end
        croppednextframe = cell(31, 1);
        
        
        % Find at what z-value cross-correlation is greatest.
        
        for j = Zr_newcen_lower:Zr_newcen_upper
            croppednextframe{j} = images{kk+1}{j}(lowlimit_new1:uplimit_new1, lowlimit_new2:uplimit_new2);%Zr_cen(ii)
            crosscorr{kk}{ii}{j} = normxcorr2(croppedim, croppednextframe{j});
            maxima(j) = max(crosscorr{kk}{ii}{j}(:));
        end
        
        % From maximum cross-correlation find displacement vector
        [value, argmax] = max(maxima);
        helpcrosscorr = normxcorr2(croppedim, croppedhelp);
        [Y_peak_first, X_peak_first] = find(helpcrosscorr(:, :)==max(helpcrosscorr(:)));
        [Y_peak, X_peak] = find(crosscorr{kk}{ii}{argmax}(:, :)==max(crosscorr{kk}{ii}{argmax}(:)));
        display(argmax)
        % Take the peaks found and fit polynomial through values to find
        % exact z-displacement
        data = zeros(35, 1);
        for j = Zr_newcen_lower:Zr_newcen_upper
            data(j) = crosscorr{kk}{ii}{j}(Y_peak, X_peak);
        end
        [arg, val] = max(data);
        valmin = val-1;
        valmax = val+1;
        
        % Fit a parabola to the crosscorrelation to find real displacement
        % due to limited resolution in z; Upper and lower limits exist.
        if valmin>0 && valmax<36
            p = polyfit([val-1, val, val+1]', data((val-1):(val+1)), 2);
        end
        
        if valmin<1
            valmin = 1;
            p = polyfit([valmin, valmin+1, valmin+2]', data((valmin):(valmin+2)), 2);
        end
        
        if valmax>35
            valmax=35;
            p = polyfit([valmax-2, valmax-1, valmax]', data((valmax-2):(valmax)), 2);
        end
        
        r = Zr_newcen_lower:0.1:Zr_newcen_upper;
        func = p(1)*r.^2+p(2)*r+p(3);
        [argmax1, argval1] = max(func);
        
        % Save offsets
        
        z_offset{kk}(ii) = (r(argval1)-Z_cen(ii));
        y_offset{kk}(ii) = (Y_peak-Y_peak_first);
        x_offset{kk}(ii) = (X_peak-X_peak_first);
        counter = counter+1;
    end
end

xoffset_fin = x_offset;
yoffset_fin = y_offset;
zoffset_fin = z_offset;
