clear; clc; close all;
oImg = imread('D:\Rashid Data\AnncientImages\extracted_dataset6\train\2_12738_.bmp');
mImg = imread('D:\Rashid Data\FCN_SementicSeg\results_data\fcn8_vgg16\2_12738_FCN8s_VGG16.bmp');
dloc = 'D:\Rashid Data\FCN_SementicSeg\results_data\custom_fcn\';
%imshow(mImg);
tic
rImg = uint8 (ones([size(oImg, 1) size(oImg, 2) 3])) * 255;
for hctr = 1:1:size(oImg, 1)
    for wctr = 1:1:size(oImg, 2)
        rp = mImg(hctr, wctr, 1); gp = mImg(hctr, wctr, 2); bp = mImg(hctr, wctr, 3);
        if and(gp > rp, gp > bp)
            rImg(hctr, wctr, :) = oImg(hctr, wctr, :);
        end
    end
end
imwrite(rImg, [dloc '2_12738_FCN8s_VGG16_ext' '.bmp'], 'bmp');
toc