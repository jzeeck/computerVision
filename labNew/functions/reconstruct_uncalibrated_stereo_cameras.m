% function [cams, cam_centers] = reconstruct_uncalibrated_stereo_cameras(F); 
%
% Method: Calculate the first and second uncalibrated camera matrix
%         from the F-matrix. 
% 
% Input:  F - Fundamental matrix with the last singular value 0 
%
% Output:   cams is a 3x4x2 array, where cams(:,:,1) is the first and 
%           cams(:,:,2) is the second camera matrix.
%
%           cam_centers is a 4x2 array, where (:,1) is the first and (:,2) 
%           the second camera center.

function [cams, cam_centers] = reconstruct_uncalibrated_stereo_cameras( F )
%%
%Cam 1
Ma = horzcat(eye(3),[0,0,0]');
cams(:,:,1) = Ma;
cam_centers(:,1) =[0,0,0,1]; 

%%
%Cam 2
S = [0,-1,1;1,0,-1;-1,1,0];
[~,~,V] = svd(F');
h = V (:,end);
cams(:,:,2) = horzcat(S*F,h);
[U,S,V] = svd(cams(:,:,2));
h = V (:,end);

for i = 1:3
    cam_centers(i,2) = h(i);
end
cam_canters(4,2) = 1;



%------------------------------
% TODO: FILL IN THIS PART
