% H = compute_homography(points1, points2)
%
% Method: Determines the mapping H * points1 = points2
% 
% Input:  points1, points2 are of the form (3,n) with 
%         n is the number of points.
%         The points should be normalized for 
%         better performance.
% 
% Output: H 3x3 matrix 
%

function H = compute_homography( points1, points2 )

n = size(points1,2);
a = points1;
b = points2;
x = 1;
y = 2;
index = 1;
for i = 1:n
    if and(not(isnan(b(x,i))), not(isnan(a(x,i))))
        alpha = [b(x,i), b(y,i), 1,    0,0,0,    -b(x,i)*a(x,i), -b(y,i)*a(x,i), -a(x,i)];
        beta  = [0,0,0,    b(x,i), b(y,i), 1,    -b(x,i)*a(y,i), -b(y,i)*a(y,i), -a(y,i)];
        Q(index,:) = alpha;
        Q(index+n,:) = beta;
        index = index + 1;
    end
end

[U,S,V] = svd(Q);

h = V (:,end);


H = reshape(h,3,3)';
