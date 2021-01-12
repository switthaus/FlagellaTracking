function [X_end] = linefit3d(xyz)
X = xyz;

X_ave=mean(X,1);            % mean; line of best fit will pass through this point  
dX=bsxfun(@minus,X,X_ave);  % residuals
C=(dX'*dX)/(size(X, 1)-1);           % variance-covariance matrix of X
[R,D]=svd(C,0);             % singular value decomposition of C; C=R*D*R'

D=diag(D);
R2=D(1)/sum(D);

x=dX*R(:,1);    % project residuals on R(:,1) 
x_min=min(x);
x_max=max(x);
dx=x_max-x_min;
Xa=(x_min-0.05*dx)*R(:,1)' + X_ave;
Xb=(x_max+0.05*dx)*R(:,1)' + X_ave;
X_end=[Xa;Xb];
