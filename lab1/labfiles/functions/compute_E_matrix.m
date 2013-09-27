% function E = compute_E_matrix( points2d, K );
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
    paOrig = points2d(:,index,2);
    pa = K(:,:,2)\paOrig;
    pa = N(:,:,1)*pa;
    pbOrig = points2d(:,index,1);
    pb = K(:,:,1)\pbOrig;
    pb = N(:,:,2)*pb;
    xa = pa(1);
    ya = pa(2);
    xb = pb(1);
    yb = pb(2);
    Q(index,:) = [xb*xa, xb*ya, xb, yb*xa, yb*ya, yb, xa, ya, 1];
end

[U,S,V] = svd(Q);
h = V (:,end);
E = reshape(h,3,3)';

E = N(:,:,2)'*reshape(h,3,3)'*N(:,:,1);
[U,S,V] = svd(E);
Scorrect = (S(1,1) + S(2,2)) / 2;
E = U * [Scorrect,0,0; 0,Scorrect,0;0,0,0] * V';

%for index=1:n
%    new_pb(:,index)'*E*new_pa(:,index);
%end
