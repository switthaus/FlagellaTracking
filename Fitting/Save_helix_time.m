cd ..
cd 'reptation_60x_9_g_L'
helix = cell(40, 1);
counter = 1;
for k = 40:80
    helix{counter} = zeros(181, 141, 8);
    counter1 = 1;
    for i = 18:26
        I = imread(sprintf('9_g_L_60X_.3ppm_10mMKHPO4pH7_9_g_L_60X_.3ppm_10mMKHPO4pH7_T%03d_Z%02d.tif', k, i));
        helix{counter}(:,:,counter1) = I(610:790, 680:820);
        counter1 = counter1+1;
    end
    counter = counter+1;
end

cd ..
cd 'Helix_over_time'