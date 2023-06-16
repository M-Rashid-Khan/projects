clc;clear all;
loc = 'D:\Rashid Data\AnncientImages\extracted_dataset5\GroundTruth_Imgs_original\';
dloc = 'D:\Rashid Data\AnncientImages\extracted_dataset5\GroundTruth_Imgs\';
list = dir ([loc '*.bmp']);

for i = 1:1:length(list)
    img = imread([loc list(i).name]);
    img = rgb2gray(img);
    img(img>0) = 1;
    imwrite(img, [dloc list(i).name ],'bmp');
end

% % read in tiff image and convert it to double format
% my_image = imread('picture.tiff');
% %my_image = my_image(:,:,1);
% % perform thresholding by logical indexing
% image_thresholded = my_image;
% image_thresholded(my_image>0) = 1;
% 
% % display result
% figure()
% subplot(1,2,1)
% imshow(my_image,[])
% title('original image')
% subplot(1,2,2)
% imshow(image_thresholded,[])
% title('thresholded image')