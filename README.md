# Flagella Tracking v2.0

This code was developed by Sven Witthaus and Toby Hess and will serve as a tool to analyze the movement of helical and straight flagella. The purpose of this project is to relate the macroscopic rheological measurements found on flagella to their microscopic diffusive properties. By measuring the diffusion coefficient of flagella we can reasonably argue why using rheology, the gel responds differently when exposed to different frequencies.

To use this code first we want to save the individual images into stacks. Each stack will contain all the images belonging to one timepoint with multiple z-slices. To do this, run SavingStacks.m to, which will save them into a "Stacks_rep" folder. Next, change the working directory to this and run MainTracking.m code. This will find the centroids and track them using closest neighbor algorithm. Finally, it will output important information such as the skeletal length over time, mean angle (theta) over time and the mean square displacement over time for a single flagella or an average.



## FlagellaTracking

1. First run file SavingStacks.m: This will create and save cells of the type "img_T001.mat", which will contain all the z-stack information in one file.
For this, one will need one reptation directory, and a directory for saving the cells. 

2. Next, change your working directory to where your cell data can be found. Here, you will perform the main analysis. The first code to run here, is FindCentroids.m as a function: [centroids, MajorAxis, hysfin] = FindCentroids(dataFolder), where dataFolder is your working directory. 

3. To visualize the resulting thresholded image together with the Flagella Orientation (according to regionprops), run Plot_Orientation_Centroid1.mat

4. The function Crosscorr_corr.mat, will calculate the displacement of the the flagella at each timepoint using crosscorrelation. Here, after running [xflagella, yflagella, zflagella, r0, cropped, Orientation] = Crosscorr_corr(hys, centroids, MajorAxis), we will obtain the displacement of x, y and z in a MATLAB cell, together with the initial poition for each Flagella we decided to track and it's Orientation as a function of time.

### To do: 
1) Speed up Thresholding Algorithm by either rewriting hysteresis for sparse matrices or cropping the field of view so that it only thresholds small regions of space. 
2) Using fitting methods to ascribe a phase to flagella and track the phase over time


### Update 08/14: 

Sped up theresholding a bit by using sparse matrices. SparseMatrices.mat runs about 3 times faster than normal hysteresis. The function FindCentroids is still quite slow though.

### Update 01/12:

Added 3D Fitting behavior. Save_helix_time.m saves a flagellum in time as a z-stack. UltimateTracking.m then uses this helix and tries fitting a helix through it, outputting the radii (a, b), pitch (ome), phi(z_angle), z displacements (z_trans), displacement due to corqscrew motion (alpha), xy-displacement (translation) and angle between the flagellum at time-point t and the first time-point.
Specifically getphase1.m is a function that rotates the flagellum to orient it around the z-axis by fitting a line through the flagella and constructing a rotation matrix. The transformed flagellum is then fitted to a helix using fitElipHelix.m
To visualize the output use plotFit.m
