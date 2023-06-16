clc
clear all ;
loc = 'E:\Datafolder\MS_Research\dataset\Bleed-Through Database Images Update\gt\';
dloc = 'E:\Datafolder\MS_Research\dataset\Bleed-Through Database Images Update\';
list = [dir([loc '*.bmp']);dir([loc '*.tif'])];

for n= 1:1:length(list)
    img_r = imread([loc list(n).name]);
    %img_r = rgb2gray(img_r);
    img_r = cat(3, img_r, img_r, img_r);
    imwrite(img_r, [dloc 'gt1\' list(n).name, '.bmp'] ,'bmp');
end