function cropped = CropFlagellum_labelsBW(Xr_cen, Yr_cen, Zr_cen, hys)

counter=1;
lowlimit = Zr_cen-10;uplimit = Zr_cen+10;
lowlimity = Yr_cen-70;uplimity = Yr_cen+70;
lowlimitx = Xr_cen-70;uplimitx = Xr_cen+70;
boxy=70; boxx=70;
diffsmall=10; diffbig=10;
if lowlimit<1
    diffsmall = 10+lowlimit-1;
    lowlimit=1;
end
if uplimit>31
    diffbig = 31-Zr_cen;
    uplimit=31;
end
if uplimity>2044
    uplimity=2044;
end
if lowlimity<1
    lowlimity=1;
    boxy=Yr_cen;
end
if uplimitx>2044
    uplimitx=2044;
end
if lowlimitx<1
    lowlimitx=1;
    boxx=Xr_cen;
end
for ii=lowlimit:uplimit
    hyscomp(:, :, counter) = full(hys{ii}(lowlimity:uplimity, lowlimitx:uplimitx));
    counter = counter+1;
end

Labels = bwlabeln(hyscomp);
%display([Xr_cen, Yr_cen])
%display(size(Labels))
%display([boxx, boxy])
indexofcentroid = median(nonzeros(Labels((boxy-2):(boxy+2), (boxx-2):(boxx+2), 9:11)));

if isnan(indexofcentroid)
    indexofcentroid=1;
end
listofind = find(Labels==indexofcentroid);
for i =1:size(listofind, 1)
[X(i), Y(i), Z(i)] = ind2sub(size(Labels), listofind(i));
end


cropped = Labels(min(X):max(X), min(Y):max(Y), min(Z):max(Z));