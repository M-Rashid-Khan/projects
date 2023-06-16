clc
clear all ;
loc = 'E:\Datafolder\MS_Research\dataset\Bleed-Through Database Images Update\rgb1\';
dloc = 'E:\Datafolder\MS_Research\dataset\Bleed-Through Database Images Update\';
list = [dir([loc '*.bmp']);dir([loc '*.tif'])];

for n= 1:1:length(list)
    img_r = imread([loc list(n).name]);
    %img_r = rgb2gray(img_r);
    imwrite(img_r, [dloc 'rgb\' num2str(n), '.bmp'] ,'bmp');
    
end