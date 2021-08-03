# Flagella Tracking v2.0

This code was developed by Sven Witthaus and Toby Hess and will serve as a tool to analyze the movement of helical and straight flagella. The purpose of this project is to relate the macroscopic rheological measurements found on flagella to their microscopic diffusive properties. By measuring the diffusion coefficient of flagella we can reasonably argue why using rheology, the gel responds differently when exposed to different frequencies.

To use this code first we want to save the individual images into stacks. Each stack will contain all the images belonging to one timepoint with multiple z-slices. To do this, run SavingStacks.m to, which will save them into a "Stacks_rep" folder. Next, change the working directory to this and run MainTracking.m code. This will find the centroids and track them using closest neighbor algorithm. Finally, it will output important information such as the skeletal length over time, mean angle (theta) over time and the mean square displacement over time for a single flagella or an average.

What follows is a detailed description of what every code in the FinalCode directory does:

1. FindCentroids is a function that, unsuprisingly, find centroids. We do this by thresholding the image using a hysteresis algorithm with sparse matrices and using regionprops to localize all the centroids in the image. Furthermore, this function also deletes all the flagella that are too short by going through each centroid and checking the box that surrounds the flagella. If it's too short (I arbitrarily chose a skeletal length of less than 15 points), I will delete this flagellum from that time frame. Unfortunately the skeletal length varies due to the tracking algorithm which causes some flagella to be deleted in some frames but not in others

2. Next, the actual tracking algorithm uses closest neighbors to find the trajectories of the flagella. Here I delete some flagella located in the edges and track all the centroids over time. To only track the most interesting flagella, I delete the flagella that have only one component in z or where the tracking algorithm failed. These flagella I call badIDs. Furthermore, I also save the individual flagellum frames (template and cropped) to see what the flagellum looks like at different time points. Unfortunately at some points the tracking algorithm still fails. I fix this by deleting all the flagella where the trajectory is 0 for the entire sample time.

3. One can check how the Tracking Algorithm works by running Plot_centroids. This will play a continously updating figure of how the flagellum looks like over time. You run Plot_centroids(hysfin, t0, tend, centroids, r0fin, xofffin, yofffin, zofffin, ID). Here hysfin and centroids are obtained by running FindCentroids. r0fin, xofffin, zofffin, yofffin are obtained from the tracking algorithm and by filtering the bad flagella. t0 and tend are the beginning and end times (where does the movie begin and where does it end). Finally ID is the id of the flagella you want to track.

4. Finally, Plot_Useful plots useful plots (duh!). It plots the skeletal length over time, the mean angle (theta) over time and the mean square displacement. You run this by writing Plot_Useful(xofffin, yofffin, zofffin, lengthfin, orfin, T, ID, excl, drift). Here, xoffin yofffin zofffin lengthfin orfin are obtained from tracking and filtering. T is how many timepoints you want to consider, ID is what id you want to plot and drift is an array of flagella that only drift. If ID=0 then it will do a moving average, by considering all the flagella except for excl (excluded). 



## Old release notes: FlagellaTracking

1. First run file SavingStacks.m: This will create and save cells of the type "img_T001.mat", which will contain all the z-stack information in one file.
For this, one will need one reptation directory, and a directory for saving the cells. 

2. Next, change your working directory to where your cell data can be found. Here, you will perform the main analysis. The first code to run here, is FindCentroids.m as a function: [centroids, MajorAxis, hysfin] = FindCentroids(dataFolder), where dataFolder is your working directory. 

3. To visualize the resulting thresholded image together with the Flagella Orientation (according to regionprops), run Plot_Orientation_Centroid1.mat

4. The function Crosscorr_corr.mat, will calculate the displacement of the the flagella at each timepoint using crosscorrelation. Here, after running [xflagella, yflagella, zflagella, r0, cropped, Orientation] = Crosscorr_corr(hys, centroids, MajorAxis), we will obtain the displacement of x, y and z in a MATLAB cell, together with the initial poition for each Flagella we decided to track and it's Orientation as a function of time.


### Update 08/14: 

Sped up theresholding a bit by using sparse matrices. SparseMatrices.mat runs about 3 times faster than normal hysteresis. The function FindCentroids is still quite slow though.

### Update 01/12:

Added 3D Fitting behavior. Save_helix_time.m saves a flagellum in time as a z-stack. UltimateTracking.m then uses this helix and tries fitting a helix through it, outputting the radii (a, b), pitch (ome), phi(z_angle), z displacements (z_trans), displacement due to corqscrew motion (alpha), xy-displacement (translation) and angle between the flagellum at time-point t and the first time-point.
Specifically getphase1.m is a function that rotates the flagellum to orient it around the z-axis by fitting a line through the flagella and constructing a rotation matrix. The transformed flagellum is then fitted to a helix using fitElipHelix.m
To visualize the output use plotFit.m
