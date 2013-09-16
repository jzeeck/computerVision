% H = det_homographies(points1, points2)
%
% Method: Determines the mapping H * points1 = points2
% 
% Input:  points1, points2 are of the form (3,n) with 
%         n is the amount of points 
%         The points should be normalized for 
%         better performance 
% 
% Output: H (3,3) matrix 
%

function H = det_homographies(points1, points2)

N = size(points1, 2);

Q = zeros(N*2, 9);
for index = 1:N,
    xa = points1(1,index);
    ya = points1(2,index);
    xb = points2(1,index);
    yb = points2(2,index);
    Q(index,:) = [xb,yb,1,0,0,0,-xb*xa,-yb*xa,-xa];
    Q(index+N,:) = [0,0,0,xb,yb,1,-xb*ya,-yb*ya,-ya];
end
Q;
[U,S,V] = svd(Q'*Q);

h = V (:,end);
% debug
%for index = 1:2*N,
%    Q(index,:)*h
%end

H = reshape(h,3,3)';
