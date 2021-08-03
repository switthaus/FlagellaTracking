function PlotUseful(xoff, yoff, zoff, length, or, timepoints, id, excl, drift)
tmax = 775;
t=linspace(1, 100, 100)*11/60;
t1=linspace(1, timepoints-1, timepoints-1)*11/60;
t2=linspace(1, timepoints-2, timepoints-2)*11/60;

figure
hold on
if id==0
    for i =setdiff(1:size(xoff, 2), excl)
        scatter(t1, length(:, i), 'DisplayName', sprintf('Flagella %01i', i))
    end
else
    scatter(t1, length(:, id), 'DisplayName', sprintf('Flagella %01i', id))
end
xlabel('Time [min]')
ylabel('Length of flagella [pix]')
legend

figure
if id==0
    for j=setdiff(1:size(xoff, 2), excl)
        %for i = 1:693
        %    for k=1:100
        %        totdis{j}(k, i) = (sum(xoff(i:i+k, j)-mean(xoff(i:i+k, drift), 2))*6.5/40).^2+(sum(yoff(i:i+k, j)-mean(yoff(i:i+k, drift), 2))*6.5/40).^2+(sum(zoff(i:i+k, j)-mean(zoff(i:i+k, drift), 2))*0.5).^2;
        %        totdis1{j}(k, i) = (sum(xoff(i:i+k, j))*6.5/40).^2+(sum(yoff(i:i+k, j))*6.5/40).^2+(sum(zoff(i:i+k, j))*0.5).^2;

         %   end
        %end
        %for ii = 1:793
        %    totdis(ii, j) = sum(xoff(1:i, j)*6.5/40).^2+sum(yoff(1:i, j)*6.5/40).^2+sum(zoff(1:i, j)*0.5).^2;
        %    totdis1(ii, j) = sum((xoff(1:i, j)-xoff(1:i, 8))*6.5/40).^2+sum((yoff(1:i, j)-yoff(1:i, 8))*6.5/40).^2+sum((zoff(1:i, j)-zoff(1:i, 8))*0.5).^2;
        %end
        %for ii=1:100
        %    M(ii, j) = mean(totdis(ii:(793-ii), j), 1);
        %    M1(ii, j) = mean(totdis(ii:(793-ii), j), 1);
        %end
        counter=1;
        for ii=470:699 % portion of sample where flagella is reptating (22: 463 699 / 25: 1:699)
            for kk=1:100
                totdis{1}(counter, kk) = sum((xoff(ii:(ii+kk), j)-xoff(ii:(ii+kk), 8))*6.5/40).^2+sum((yoff(ii:(ii+kk), j)-yoff(ii:(ii+kk), 8))*6.5/40).^2+sum((zoff(ii:(ii+kk), j)-zoff(ii:(ii+kk), 8))*0.5).^2;
            end
            counter=counter+1;
        end
    end
    %for j=setdiff(1:size(xoff, 2), excl)
    %    meandis{j} = mean(totdis{j}, 2);
    %    meandis1{j} = mean(totdis1{j}, 2);        
    %end
    %findis = mean(cell2mat(meandis), 2);
    %findis1 = mean(cell2mat(meandis1), 2);
    findis = mean(totdis{1}, 1);
    scatter(t, findis)
else
    for i = 1:(timepoints-1)
        totdis(i) = sum(xoff(1:i, id)*6.5/40).^2+sum(yoff(1:i, id)*6.5/40).^2+sum(zoff(1:i, id)*0.5).^2;
        totdis1(i) = sum((xoff(1:i, id)-xoff(1:i, 8))*6.5/40).^2+sum((yoff(1:i, id)-yoff(1:i, 8))*6.5/40).^2+sum((zoff(1:i, id)-zoff(1:i, 8))*0.5).^2;
    end
    scatter(t1, totdis)
    hold on
    scatter(t1, totdis1)
    legend('Raw Displacement', 'Subtracted drift')
    hold off
end
xlabel('Time [min]')
ylabel('Mean Square Displacement [um^2]')

figure
if id==0
    for j=1:setdiff(1:size(xoff, 2), excl)
        for i=1:693
            for k=1:100
                dots{j}(k, i) = acos(dot(or{j}(i+k, :)/norm(or{j}(i+k, :)), or{j}(i, :)/norm(or{j}(i, :))));
            end
        end
    end
    for i=1:setdiff(1:size(xoff, 2), excl)
        meandot{i} = mean(dots{i}, 2);
    end
    dotfinal = mean(cell2mat(meandot), 2);
    scatter(t, dotfinal)
else
     for i=1:(timepoints-2)
         dots(i) = acos(dot(or{id}(i, :)/norm(or{id}(i, :)), or{id}(1, :)/norm(or{id}(1, :))));
     end
     plot(t2, dots*180/pi, '-')
end
    

xlabel('Time [min]')
ylabel('Mean Angle [deg]')
