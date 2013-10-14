% H = compute_rectification_matrix(points1, points2)
%
% Method: Determines the mapping H * points1 = points2
% 
% Input: points1, points2 of the form (4,n) 
%        n has to be at least 5
%
% Output:  H (4,4) matrix 
% 

function H = compute_rectification_matrix( points1, points2 )

n = size(points1, 2);

pPrime = points2;
p = points1;

for i = 1:n
    x = p(1,i);
    y = p(2,i);
    z = p(3,i);
    w = p(4,i);
    xp = pPrime(1,i);
    yp = pPrime(2,i);
    zp = pPrime(3,i);
    
    W((i*3) - 2,:) = [x,y,z,w,0,0,0,0,0,0,0,0,-x*xp,-y*xp,-z*xp,-w*xp];
    W((i*3) - 1,:) = [0,0,0,0,x,y,z,w,0,0,0,0,-x*yp,-y*yp,-z*yp,-w*yp];
    W((i*3),:)     = [0,0,0,0,0,0,0,0,x,y,z,w,-x*zp,-y*zp,-z*zp,-w*zp];  
end

[~,~,V] = svd(W);
h = V (:,end);

H = reshape(h,4,4)';