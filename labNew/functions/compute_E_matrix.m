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

a = 1;
b = 2;

n = size(points2d, 2);
pa(:,:) = K(:,:,a)\points2d(:,:,a);
pb(:,:) = K(:,:,b)\points2d(:,:,b);

N = compute_normalization_matrices(reshape([pa pb],[size(pa, 1) size(pa, 2) 2]));
Na = N(:,:,a);
Nb = N(:,:,b);

pa = Na* pa;
pb = Nb* pb;


for i=1:n
    W(i,:) = [pb(1,i)*pa(1,i), pb(1,i)*pa(2,i), pb(1,i), pb(2,i)*pa(1,i), pb(2,i)*pa(2,i), pb(2,i), pa(1,i), pa(2,i), 1];
end

[U,S,V] = svd(W);
h = V (:,end);

E = reshape(h,3,3)';
F = E;
E = Nb'*F*Na;
[U,S,V] = svd(E);

Scorrect = (S(1,1) + S(2,2))/2;

E = U*[Scorrect,0,0;0,Scorrect,0;0,0,0]*V';
%%error check
% for i=1:n
%     if normalize
%         error(i,:) = pb(:,i)'*F*pa(:,i);
%     else
%         error(i,:) = pb(:,i)'*E*pa(:,i);   
%     end
% end
% 
% error;



