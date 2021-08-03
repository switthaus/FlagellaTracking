function length=skellength(pic)

helixnew = imgaussfilt3(pic, 1);
[tri, hys] = hysteresis3d(helixnew, 0.35, 0.46, 26);

[xlen,ylen,zlen]=size(hys);
Z=zeros(xlen,ylen,zlen);

%create connectivity map, find biggest blob, skeletonize
CC=bwconncomp(hys);
numPixels=cellfun(@numel,CC.PixelIdxList);
[biggest,idx]=max(numPixels);
Z(CC.PixelIdxList{idx})=1;
Z=logical(Z);
skel=bwskel(Z);

%find length
CC=bwconncomp(skel);
length=size(CC.PixelIdxList{1,1});