function [hys] = SparseHysteresis(I1, t1, t2)

img = cell(size(I1, 3));
for i = 1:size(img, 1)
    img{i} = sparse(double(I1(:, :, i)));
end

for i =1:size(img, 1)
    minima(i)=min(img{i}(:));                % min image intensity value
    maxima(i)=max(img{i}(:));                % max image intensity value
end
minv = min(full(minima));
maxv = max(full(maxima));

t1v=t1*(maxv-minv)+minv;
t2v=t2*(maxv-minv)+minv;
abovet1 = cell(size(img, 1), 1); abovet2 = cell(size(img, 1), 1); B = cell(size(img, 1), 1); %col = cell(size(img, 1), 1);
for i =1:size(img, 1)
    abovet1{i} = img{i}>t1v;
    abovet2{i} = img{i}>t2v;
    [B{i}, L] = bwboundaries(full(abovet2{i}), 'noholes');
    %[row{i}, col{i}] = ind2sub(size(img{i}), find(abovet2{i}==1));
end

hys = abovet2;

for kk = 1:size(img, 1)
    if kk==1
            lower = 1;
            upper = 2;
    end
    if kk==size(img, 1)
            lower = kk-1;
            upper = kk;
    end
    if kk ~= 1 && kk ~= size(img, 1)
            lower = kk-1;
            upper = kk+1;
    end
    for ii = 1:size(B{kk})
        for ll = size(B{kk}{ii})
            row = B{kk}{ii}(ll, 1);
            col = B{kk}{ii}(ll, 2);
            for jj=lower:upper
                if row==1 || col==1 || col>=size(img{1}, 1) || row>=size(img{1}, 1)
                    continue
                end
                if full(abovet1{jj}(row+1, col))==1
                    hys{jj}(row+1, col)=1;
                end
                if full(abovet1{jj}(row-1, col))==1
                    hys{jj}(row-1, col)=1;
                end
                if full(abovet1{jj}(row, col+1))==1
                    hys{jj}(row, col+1)=1;
                end
                if full(abovet1{jj}(row, col-1))==1
                    hys{jj}(row, col-1)=1;
                end
                if full(abovet1{jj}(row+1, col+1))==1
                    hys{jj}(row+1, col+1)=1;
                end
                if full(abovet1{jj}(row+1, col-1))==1
                    hys{jj}(row+1, col-1)=1;
                end
                if full(abovet1{jj}(row-1, col+1))==1
                    hys{jj}(row-1, col+1)=1;
                end
                if full(abovet1{jj}(row-1, col-1))==1
                    hys{jj}(row-1, col-1)=1;
                end
            end
        end
    end
end
