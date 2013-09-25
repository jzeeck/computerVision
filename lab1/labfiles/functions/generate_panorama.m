% Script: generate_panorama
%
% Method: Genetrate one image out of multiple images. 
%         Where all images are from a camera with the 
%         same(!) center of projection. All the images 
%         are registered to one reference view (ref_view)
%

% adjustments
format compact;
format short g;

% Parameters fot the process 
ref_view = 3; % Reference view
am_cams = 3; % Amount of cameras
name_file_images = 'names_images_kthsmall.txt';
name_panorama = '../images/panorama_image.jpg';

% initialise
homographies = cell(am_cams,1); % we have: point(ref_view) = homographies{i} * point(image i)
data = [];
data_norm = [];

% load the images 
[images, name_loaded_images] = load_images_grey(name_file_images, am_cams);

% click some points or load the data 
%load '/afs/nada.kth.se/home/x/u1gxzf8x/Projects/computerVision/lab1/labfiles/data/data_kth2.mat'; % if you load a clicked sequnce 
load '/Users/Johan/Projects/computerVision/lab1/labfiles/data/data_kth5.mat';
%data = click_multi_view(images, am_cams, data, 0); % for clicking and displaying data
%save ('/Users/Johan/Projects/computerVision/lab1/labfiles/data/data_kth9.mat', 'data');

% normalize the data
[norm_mat] = get_normalization_matrices(data);
for hi1 = 1:am_cams
  data_norm(hi1*3-2:hi1*3,:) = norm_mat(hi1*3-2:hi1*3,:) * data(hi1*3-2:hi1*3,:); 
end

% determine all homographies to a reference view

%------------------------------
%
% FILL IN THIS PART
%
% Remember, you have to set 
% homographies{ref_view} as well
%
%------------------------------
temp = 1;
while (not(isnan(data(1,temp))))
    temp = temp +1;
end
for j = 1:(am_cams-1)

    p1 = [data((1+3*(j-1)):(3+3*(j-1)),(1+(temp-1)*(j-1)):(temp-1+(temp-1)*(j-1)))];
    p2 = [data(7:9,(1+(temp-1)*(j-1)):(temp-1+(temp-1)*(j-1)))];

    Hown = det_homographies(p2,p1);
    homographies{j} = Hown;
    
    p1 = [data_norm((1+3*(j-1)):(3+3*(j-1)),(1+(temp-1)*(j-1)):(temp-1+(temp-1)*(j-1)))];
    p2 = [data_norm(7:9,(1+(temp-1)*(j-1)):(temp-1+(temp-1)*(j-1)))];
    
    Hown = det_homographies(p2,p1);
    normHown = inv(norm_mat(end-2:end,:))*Hown*norm_mat(j*3-2:j*3,:);
    %homographies{j} = normHown;
    
end

homographies{3} = eye(3);
%homographies{3} = inv(norm_mat(3*3-2:3*3,:))*eye(3)*norm_mat(3*3-2:3*3,:)




% check error in the estimated homographies
for hi1 = 1:am_cams
  [error_mean, error_max] = check_error_homographies(homographies{hi1},data(3*hi1-2:3*hi1,:),data(3*ref_view-2:3*ref_view,:));
  fprintf('Between view %d and ref. view; ', hi1); % Info
  fprintf('average error: %5.2f; maximum error: %5.2f \n', error_mean, error_max); 
end

% create the new warped image
panorama_image = generate_warped_image(images, homographies);

% show it
figure;
show_image_grey(panorama_image);

% save it 
save_image_grey(name_panorama,panorama_image);
