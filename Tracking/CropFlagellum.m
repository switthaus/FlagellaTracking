function [cropped, croppedim, p] = CropFlagellum(Xr_cen, Yr_cen, Zr_cen, hys, image)

p1 = 10; p2 = 10; p3 = 10; p4 = 10; satisfied = 0;
while ~ satisfied
            lowlimit1 = Yr_cen-p4; lowlimit2 = Xr_cen-p1;
            uplimit1 = Yr_cen+p3; uplimit2 = Xr_cen+p2;
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
            
            cropped = full(hys(lowlimit1:uplimit1, lowlimit2:uplimit2));
            croppedim = image(lowlimit1:uplimit1, lowlimit2:uplimit2);
            if isempty(cropped)
                display('Flagella out of frame')
            end
            
            if lowlimit1==1 | lowlimit2==1 | uplimit1==size(hys, 1) | uplimit2 == size(hys, 2)
                times_it_happened(kk) = times_it_happened(kk)+1;
                satisfied = 1;
            end
            if any(1==cropped(:, 1, 1))
                p1 = p1+1;
                continue
            end
            if any(1==cropped(:, end, 1))
                p2 = p2+1;
                continue
            end
            if any(1==cropped(1, :, 1))
                p4 = p4+1;
                continue
            end
            if any(1==cropped(end, :, 1))
                p3 = p3+1;
                continue
            end
            
            satisfied = 1;
            
end

p = [p1, p2, p3, p4];