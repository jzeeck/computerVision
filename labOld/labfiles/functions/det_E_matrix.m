% function E = det_E_matrix(points1, points2, K1, K2);
%
% Method: Calculate the E matrix between two views from
%         point correspondences: points2^T * E * points1 = 0
%         we use the normalize 8-point algorithm and 
%         enforce the constraint that the three singular 
%         values are: a,a,0. The data will be normalized here. 
%         Finally we will check how good the epipolar constraints:
%         points2^T * E * points1 = 0 are fullfilled.
% 
% Input:  points1, points2 of size (3,n) 
%         K1 is the internal camera matrix of the first camera; (3,3) matrix
%         K2 is the internal camera matrix of the second camera; (3,3) matrix
% 
% Output: E (3,3) with the singular values (a,a,0) 
% 

function E = det_E_matrix(points1, points2, K1, K2)

n = size(points1, 2);

for i=1:n
    pa(:,i) = K1\points1(:,i);
    pb(:,i) = K2\points2(:,i);
end

for i=1:n
    Q(i,:) = [pb(1,i)*pa(1,i), pb(1,i)*pa(2,i), pb(1,i), pb(2,i)*pa(1,i), pb(2,i)*pa(2,i), pb(2,i), pa(1,i), pa(2,i), 1];
end
Q;
[U,S,V] = svd(Q);
h = V (:,end);

E = reshape(h,3,3)';
for i=1:n
    pb(:,i)'*E*pa(:,i)
end