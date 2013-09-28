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

points1 = points2d(:,:,1);
points2 = points2d(:,:,2);
K1 = K(:,:,1);
K2 = K(:,:,2);

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
    error(i,:) = pb(:,i)'*E*pa(:,i);
end

error




% 
% 
% n = size(points2d, 2);
% N = compute_normalization_matrices(points2d);
% 
% for i=1:n
%     pa(:,i) = K(:,:,1)\points2d(:,i,1);
%     pb(:,i) = K(:,:,1)\points2d(:,i,2);
% %     pa(:,i) = N(:,:,1)*K(:,:,1)\points2d(:,i,1);
% %     pb(:,i) = N(:,:,2)*K(:,:,2)\points2d(:,i,2);
% end
% 
% for i=1:n
%     Q(i,:) = [pb(1,i)*pa(1,i), pb(1,i)*pa(2,i), pb(1,i), pb(2,i)*pa(1,i), pb(2,i)*pa(2,i), pb(2,i), pa(1,i), pa(2,i), 1];
% end
% Q;
% [U,S,V] = svd(Q);
% h = V (:,end);
% 
% E = reshape(h,3,3)';
% 
% % [U,S,V] = svd(E);
% % Scorrect = (S(1,1) + S(2,2)) / 2;
% % E = U * [Scorrect,0,0; 0,Scorrect,0;0,0,0] * V';
% % for i=1:n
% %     pb(:,i)'*E*pa(:,i)
% % end
% 
% 
% 
% 
% 











% n = size(points2d, 2);
% N = compute_normalization_matrices(points2d);
% 
% for i = 1:n
%     pa = K(:,:,1)\points2d(:,i,1);
%     pb = K(:,:,2)\points2d(:,i,2);
%     %pa = N(:,:,1)*pa;
%     %pb = N(:,:,2)*pb;
%     Q(i,:) = [ pb(1)*pa(1),pb(1)*pa(2),pb(1),  pb(2)*pa(1), pb(2)*pa(2),pb(2),  pa(1), pa(2), 1];
% end
% 
% [U,S,V] = svd(Q);
% h = V (:,end);
% E = reshape(h,3,3);
% 
% for i = 1:n
%     pa = K(:,:,1)\points2d(:,i,1);
%     pb = K(:,:,2)\points2d(:,i,2);
%     
%     pb'*E*pa
%     
% end

% [U,S,V] = svd(E);
% Scorrect = (S(1,1) + S(2,2)) / 2;
% E = U * [Scorrect,0,0; 0,Scorrect,0;0,0,0] * V';

