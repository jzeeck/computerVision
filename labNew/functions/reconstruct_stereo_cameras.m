% function [cams, cam_centers] = reconstruct_stereo_cameras(E, K1, K2, data); 
%
% Method:   Calculate the first and second camera matrix. 
%           The second camera matrix is unique up to scale. 
%           The essential matrix and 
%           the internal camera matrices are known. Furthermore one 
%           point is needed in order solve the ambiguity in the 
%           second camera matrix.
%
%           Requires that the number of cameras is C=2.
%
% Input:    E is a 3x3 essential matrix with the singular values (a,a,0).
%
%           K is a 3x3xC array storing the internal calibration matrix for
%           each camera.
%
%           points2d is a 3xC matrix, storing an image point for each camera.
%
% Output:   cams is a 3x4x2 array, where cams(:,:,1) is the first and 
%           cams(:,:,2) is the second camera matrix.
%
%           cam_centers is a 4x2 array, where (:,1) is the first and (:,2) 
%           the second camera center.
%

function [cams, cam_centers] = reconstruct_stereo_cameras( E, K, points2d )
%Solve First entry
%solve Ma
Ma = eye(3);
Ma(:,4) =[0,0,0]; 
cams(:,:,1) = Ma;
Ma = K(:,:,1)*Ma;
cams(:,:,1) = Ma;
cam_centers(:,1) = [0,0,0,1];

%Set the other entries to 0
cams(:,:,2) =[0,0,0,0;0,0,0,0;0,0,0,0];
cam_centers(:,2) = [0,0,0,0];


%Solve Second entry
%Position first
[U,S,V] = svd(E);
t = V (:,end);
%we now have t but we do not know if it is t or -t

%Solve possible rotation. 
%R1 and R2 is two possible rotations
W = [0,-1,0;1,0,0;0,0,1];
R1 = U*W*V';
R2 = U*W'*V';

eyet = eye(3);
eyet(:,4) = t';
eyemt(:,4) = -t'; 

%%
%Figure out which one

Kb = K(:,:,2);
Mbtemp(:,:,1) = Kb*R1*eyet;
Mbtemp(:,:,2) = Kb*R1*eyemt;
Mbtemp(:,:,3) = Kb*R2*eyet;
Mbtemp(:,:,4) = Kb*R2*eyemt;
%Can be anoyone of these 4 solutions. need to figure out which
for i = 1:size(Mbtemp,3)
    cams(:,:,2) = Mbtemp(:,:,i);
    points3d(:,:,i) = reconstruct_point_cloud(cams, points2d);
    points3d(end,i) = 1;
end

for i = 1:size(Mbtemp,3)
    %global_point = zeros(1,3)
    if i == 1
        global_point = R1*eyet*points3d;
    elseif i == 2
        global_point = R1*eyemt*points3d;
    elseif i == 3
        global_point = R2*eyet*points3d;
    elseif i == 4
        global_point = R2*eyemt*points3d;
    end
    global_point
    if sign(points3d(3,i)) == sign(1)
        
    end
end
%%
%%Just set shit.
for i = 1:size(t)
    cam_centers(i,2) = t(i);
end
cam_centers(4,2) = 1;

cams(:,:,2) = Mbtemp(:,:,3);

