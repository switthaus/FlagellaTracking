cd C:\Users\Switthaus\Documents\MATLAB\Dogic\Flagella\reptation_60x_9_g_L
DIR = pwd;
timepoints = 100;
for k = 97:timepoints
    S = dir(fullfile(DIR,sprintf('9_g_L_60X_.3ppm_10mMKHPO4ph7_9_g_L_60X_.3ppm_10mMKHPO4ph7_T%03d_*.tif', k)));
    numb_stacks = numel(S);
    F = cell(numb_stacks, 1);
    Im_stack = cell(numb_stacks, 1);
    for i = 1:numb_stacks
        F{i, 1} = fullfile(DIR, S(i).name);
        Im_stack{i, 1} = imread(F{i, 1});
    end
    cd ..
    cd Stacks_rep3
    %Im_comp = cat(35, Im_stack{:, 1});
    %imwrite(Im_comp, sprintf('img_T%03d.tif', k), 'tif');
    save(sprintf('img_T%03d.mat', k), 'Im_stack')
    cd ..
    cd reptation_60x_9_g_L
end