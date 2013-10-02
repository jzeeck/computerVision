% Method:   compute all normalization matrices.  
%           It is: point_norm = norm_matrix * point. The norm_points 
%           have centroid 0 and average distance = sqrt(2))
% 
%           Let N be the number of points and C the number of cameras.
%
% Input:    points2d is a 3xNxC array. Stores un-normalized homogeneous
%           coordinates for points in 2D. The data may have NaN values.
%        
% Output:   norm_mat is a 3x3xC array. Stores the normalization matrices
%           for all cameras, i.e. norm_mat(:,:,c) is the normalization
%           matrix for camera c.

function norm_mat = compute_normalization_matrices( points2d )

c = size(points2d, 3);
const = sqrt(2);
norm_mat = zeros(3,3,c);

for camera_dimension = 1:c
    
    centroid = zeros(3,1);
	distance = 0;
    n = 0;
    
	for number_of_points = 1:size(points2d,2)
        p = points2d(:,number_of_points,camera_dimension);
        %do some stuff if they are valid
        if not(isnan(p(1)))
            centroid = centroid + p;
            n = n + 1;
        end
    end
    centroid = centroid/n;
    
    for number_of_points = 1:size(points2d,2)
        p = points2d(:,number_of_points,camera_dimension);
        if not(isnan(p(1)))
            distance = distance + norm(p - centroid);
        end
    end
    distance = distance/n;
    
    N = eye(3);
    N(1,1) = const/distance;
    N(1,3) = -const*centroid(1)/distance;
    N(2,2) = const/distance;
    N(2,3) = -const*centroid(2)/distance;
    norm_mat(:,:,camera_dimension) = N;
end