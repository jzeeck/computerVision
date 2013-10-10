% function [error_average, error_max] = check_reprojection_error(data, cam, model)
%
% Method:   Evaluates average and maximum error 
%           between the reprojected image points (cam*model) and the 
%           given image points (data), i.e. data = cam * model 
%
%           We define the error as the Euclidean distance in 2D.
%
%           Requires that the number of cameras is C=2.
%           Let N be the number of points.
%
% Input:    points2d is a 3xNxC array, storing all image points.
%
%           cameras is a 3x4xC array, where cams(:,:,1) is the first and 
%           cameras(:,:,2) is the second camera matrix.
%
%           point3d 4xN matrix of all 3d points.
%       
% Output:   
%           The average error (error_average) and maximum error (error_max)
%      

function [error_average, error_max] = check_reprojection_error( points2d, cameras, point3d )
error_max = 0;
error_average = 0

[~,N,C] = size(points2d);

for n = 1:N
    for c = 1:C
        e = norm(homogeneous_to_cartesian(cameras(:,:,c) * point3d(:,n)) - homogeneous_to_cartesian(points2d(:,n,c)));
        error_average = error_average + e;
        if e > error_max
           error_max = e; 
        end

    end
end
error_average = error_average/(N*C);


%error = norm(homogeneous_to_cartesian(cameras(:,:,1) * point3d(:,1)) - homogeneous_to_cartesian(points2d(:,1,1)))
