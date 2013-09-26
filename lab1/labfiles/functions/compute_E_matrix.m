% function E = compute_E_matrix( points1, points2, K1, K2 );
%
% Method:   Calculate the E matrix between two views from
%           point correspondences: points2^T * E * points1 = 0
%           we use the normalize 8-point algorithm and 
%           enforce the constraint that the three singular 
%           values are: a,a,0. The data will be normalized here. 
%           Finally we will check how good the epipolar constraints:
%           points2^T * E * points1 = 0 are fullfilled.
% 
%           Requires that the number of cameras is C=2.
% 
% Input:    points2d is a 3xNxC array storing the image points.
%
%           K is a 3x3xC array storing the internal calibration matrix for
%           each camera.
%
% Output:   E is a 3x3 matrix with the singular values (a,a,0).

function E = compute_E_matrix( points2d, K )

n = size(points2d, 2);

N = compute_normalization_matrices(points2d);

for index=1:n
    pa(:,index) = K(:,:,1)\points2d(:,index,1);
    pa(:,index) = N(1:3,:)*pa(:,index);
    pb(:,index) = K(:,:,2)\points2d(:,index,2);
    pb(:,index) = N(4:6,:)*pb(:,index);
end

for index=1:n
    xa = pa(1, index);
    ya = pa(2, index);
    xb = pb(1, index);
    yb = pb(2, index);
    Q(index,:) = [xb*xa, xb*ya, xb, yb*xa, yb*ya, yb, xa, ya, 1];
end

[U,S,V] = svd(Q'*Q);
h = V (:,end);

E = N(4:6,:)'*reshape(h,3,3)'*N(1:3,:);

%for index=1:n
%    new_pb(:,index)'*E*new_pa(:,index);
%end
