function [cropped, croppedim, p] = CropFlagellum_labels(Xr_cen, Yr_cen, Zr_cen, hys, image)

counter=1;
% Make an area big enough to capture all of the flagellum
lowlimit = Zr_cen-10;
uplimit = Zr_cen+10;
if lowlimit<1
    lowlimit=1;
end
if uplimit>31
    uplimit=31;
end
for ii=lowlimit:uplimit
    hyscomp(:, :, counter) = full(hys{ii}((Yr_cen-90):(Yr_cen+90), (Xr_cen-90):(Xr_cen+90)));
    counter = counter+1;
end
isosurface(hyscomp, 0.5);
Labels = bwlabeln(hyscomp);
%display(size(hyscomp))
low = Zr_cen-lowlimit;
lower = low-2; lowup = low+2;
if lower<1
    lower=1;
end
if lowup>size(Labels, 3)
    lowup=size(Labels, 3);
end
%display(size(Labels))
%display([Zr_cen, lower, lowup])
indexofcentroid = median(nonzeros(Labels(88:92, 88:92, lower:lowup)));
if isnan(indexofcentroid)
    cropped = 0;
    croppedim= 0;
    p = 0;
else
    listofind = find(Labels==indexofcentroid);
    %display(indexofcentroid)
    for i =1:size(listofind, 1)
        [X(i), Y(i), Z(i)] = ind2sub(size(Labels), listofind(i));
    end


    cropped = Labels(min(X):max(X), min(Y):max(Y), min(Z):max(Z));

    p1 = abs(min(X)-90); p2 = abs(max(X)-90); p3 = abs(min(Y)-90); p4 = abs(max(Y)-90); p5 = abs(min(Z)-10); p6 = abs(max(Z)-10);
    p = [p1, p2, p3, p4, p5, p6];
    lowlimit1=Zr_cen-p5; uplimit1=Zr_cen+p6;
    if Zr_cen-p5<1
        lowlimit1=1;
    end
    if Zr_cen+p6>31
        uplimit1=31;
    end
    croppedim = image((Yr_cen-p1):(Yr_cen+p2), (Xr_cen-p3):(Xr_cen+p4), lowlimit1:uplimit1);
end