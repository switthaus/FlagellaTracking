# FlagellaTracking

1. First run file SavingStacks.m: This will create and save cells of the type "img_T001.mat", which will contain all the z-stack information in one file.
For this, one will need one reptation directory, and a directory for saving the cells. 

2. Next, change your working directory to where your cell data can be found. Here, you will perform the main analysis. The first code to run here, is FindCentroids.m as a function: [centroids, MajorAxis, hysfin] = FindCentroids(dataFolder), where dataFolder is your working directory. 

3. To visualize the resulting thresholded image together with the Flagella Orientation (according to regionprops), run Plot_Orientation_Centroid1.mat

4. The function Crosscorr_corr.mat, will calculate the displacement of the the flagella at each timepoint using crosscorrelation. Here, after running [xflagella, yflagella, zflagella, r0, cropped, Orientation] = Crosscorr_corr(hys, centroids, MajorAxis), we will obtain the displacement of x, y and z in a MATLAB cell, together with the initial poition for each Flagella we decided to track and it's Orientation as a function of time.

To do: 1)Speed up Thresholding Algorithm by either rewriting hysteresis for sparse matrices or cropping the field of view so that it only thresholds small regions of space.
2) Using fitting methods to ascribe a phase to flagella and track the phase over time


Update 08/14: Sped up theresholding a bit by using sparse matrices. SparseMatrices.mat runs about 3 times faster than normal hysteresis. The function FindCentroids is still quite slow though.
