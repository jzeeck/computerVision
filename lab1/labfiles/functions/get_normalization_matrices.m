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
const = sqrt(2);
%loop over cameras
for y = 1:am_cams
    %reset all values used.
    centroid = zeros(3,1);
    n = 0;
    distance = 0;
    
    %loop over points
    for x = 1:am_points
        %fprintf('x = %d, y = %d\n', x, y);
        p = data(1+((y-1)*3):3+((y-1)*3),x:x);
        %do some stuff if they are valid
        if not(isnan(p(1)))
            centroid = centroid + p;
            n = n + 1;
        end
    end
    centroid = centroid/n;
    %once centroid is calculated we can do distance.
    for x = 1:am_points
        p = data(1+((y-1)*3):3+((y-1)*3),x:x);
        if not(isnan(p(1)))
            distance = norm(p - centroid);
        end
    end
    distance = distance/n;
    
    N = eye(3);
    N(1,1) = const/distance;
    N(1,3) = -const*centroid(1)/distance;
    N(2,2) = const/distance;
    N(2,3) = -const*centroid(2)/distance;
    norm_mat(y*3-2:y*3,:) = N;
end

%norm_mat


% as a first test 
%for hi1 = 1:am_cams
%  norm_mat(hi1*3-2:hi1*3,:) = eye(3);
%end





