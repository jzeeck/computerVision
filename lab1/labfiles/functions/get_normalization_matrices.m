% function [norm_mat] = get_normalization_matrix(data);   
%
% Method: get all normalization matrices.  
%         It is: point_norm = norm_matrix * point. The norm_points 
%         have centroid 0 and average distance = sqrt(2))
% 
% Input: data (3*m,n) (not normalized) the data may have NaN values 
%        for m cameras and n points 
%        
% Output: norm_mat is a 3*m,3 matrix, which consists of all 
%         normalization matrices matrices, i.e. norm_mat(1:3,:) is the 
%         matrix for camera 1 
%

function [norm_mat] = get_normalization_matrix(data);


% get Info 
am_cams = size(data,1)/3;  
am_points = size(data,2);   

%Calc centroid
centroid = zeros(3,1);
n = 0;
for y = 1:3:size(data,1)
    for x = 1:size(data,2)
        %X = fprintf('x = %d, y = %d\n', x, y);
        p = data(y:y+2,x:x);
        if not(isnan(p(1)))
            centroid = centroid + p;
            n = n + 1;
        end
    end
    
end
centroid = centroid/n
%Calc distance
distance = zeros(3,1);
for y = 1:3:size(data,1)
    for x = 1:size(data,2)
        %X = fprintf('x = %d, y = %d\n', x, y);
        p = data(y:y+2,x:x);
        if not(isnan(p(1)))
            distance = abs(p - centroid);
        end
    end
    
end
distance = distance/n

N = zeros(3);
const = sqrt(2);


% as a first test 
for hi1 = 1:am_cams
  norm_mat(hi1*3-2:hi1*3,:) = eye(3);
end





