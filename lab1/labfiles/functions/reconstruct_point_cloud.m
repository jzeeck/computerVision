% function model = reconstruct_point_cloud(cam, data)
%
% Method:   Determines the 3D model points by triangulation
%           of a stereo camera system. We assume that the data 
%           is already normalized 
% 
%           Requires that the number of cameras is C=2.
%           Let N be the number of points.
%
% Input:    points2d is a 3xNxC array, storing all image points.
%
%           cameras is a 3x4xC array, where cameras(:,:,1) is the first and 
%           cameras(:,:,2) is the second camera matrix.
% 
% Output:   points3d 4xN matrix of all 3d points.


function points3d = reconstruct_point_cloud( cameras, points2d )

N = size(points2d, 2);

C = 2;

ma = cameras(:,:,1);
mb = cameras(:,:,2);

for pointIndex = 1:1%loop maybe?
    pointA = (:,pointIndex,1);
    pointB = (:,pointIndex,2);
    xa = pointA(1);
    ya = pointA(2);
    xb = pointB(1);
    yb = pointB(2);
    Q(1,:) = [(xa*ma(3,1))-ma(1,1), (xa*ma(3,2))-ma(1,2), (xa*ma(3,3))-ma(1,3), (xa*ma(3,4))-ma(1,4)];
    Q(2,:) = [(ya*ma(3,1))-ma(2,1), (ya*ma(3,2))-ma(2,2), (ya*ma(3,3))-ma(2,3), (ya*ma(3,4))-ma(2,4)];
    Q(3,:) = [(xb*mb(3,1))-mb(1,1), (xb*mb(3,2))-mb(1,2), (xb*mb(3,3))-mb(1,3), (xb*mb(3,4))-mb(1,4)];
    Q(4,:) = [(xb*mb(3,1))-mb(2,1), (xb*mb(3,2))-mb(2,2), (xb*mb(3,3))-mb(2,3), (xb*mb(3,4))-mb(2,4)];
    
    [U,S,V] = svd(Q'*Q)
    h = V (:,end)
    %store each entry in the points 3d?
    
end

%------------------------------
% TODO: FILL IN THIS PART


[U,S,V] = svd(Q'*Q);

