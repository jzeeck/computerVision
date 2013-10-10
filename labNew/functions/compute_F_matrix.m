% function F = compute_F_matrix(points1, points2);
%
% Method:   Calculate the F matrix between two views from
%           point correspondences: points2^T * F * points1 = 0
%           We use the normalize 8-point algorithm and 
%           enforce the constraint that the three singular 
%           values are: a,b,0. The data will be normalized here. 
%           Finally we will check how good the epipolar constraints:
%           points2^T * F * points1 = 0 are fullfilled.
% 
%           Requires that the number of cameras is C=2.
% 
% Input:    points2d is a 3xNxC array storing the image points.
%
% Output:   F is a 3x3 matrix where the last singular value is zero.

function F = compute_F_matrix( points2d )

a = 1;
b = 2;

n = size(points2d, 2);
pa(:,:) = points2d(:,:,a);
pb(:,:) = points2d(:,:,b);

N = compute_normalization_matrices(points2d);
Na = N(:,:,a);
Nb = N(:,:,b);

pa = Na* pa;
pb = Nb* pb;


for i=1:n
    W(i,:) = [pb(1,i)*pa(1,i), pb(1,i)*pa(2,i), pb(1,i), pb(2,i)*pa(1,i), pb(2,i)*pa(2,i), pb(2,i), pa(1,i), pa(2,i), 1];
end

[U,S,V] = svd(W);
h = V (:,end);

F = reshape(h,3,3)';
F = Nb'*F*Na;
% [U,S,V] = svd(F);
% 
% Scorrect = (S(1,1) + S(2,2))/2;
% 
% F = U*[Scorrect,0,0;0,Scorrect,0;0,0,0]*V';