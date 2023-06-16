clc; clear; close all;

rng('shuffle');

dloc = 'D:\Rashid Data\AnncientImages\extracted_dataset2\';
loc = 'D:\Rashid Data\AnncientImages\images\';
list = dir([loc '*.bmp']);

patchHW = [64 64];

%for ii = 1:1:length(list)
   
simg = imread([loc list(5).name]);
dimg = imread(['D:\Rashid Data\AnncientImages\GroundTruth_Imgs\' list(5).name]);
%image1
% simg = imcrop(simg,[381 23 1447 231]);
% dimg = imcrop(dimg,[381 23 1447 231]);
% simg = imcrop(simg,[825 291 1349 503]);
% dimg = imcrop(dimg,[825 291 1349 503]);
%image2
% simg = imcrop(simg,[614 3 1352 93]);
% dimg = imcrop(dimg,[614 3 1352 93]);
% simg = imcrop(simg,[850 102 1179 182]);
% dimg = imcrop(dimg,[850 102 1179 182]);
%image3
% simg = imcrop(simg,[86 26 1691 394]);
% dimg = imcrop(dimg,[86 26 1691 394]);
% image4
% simg = imcrop(simg,[1024 23 2371 505]);
% dimg = imcrop(dimg,[1024 23 2371 505]);
%image5
simg = imcrop(simg,[711 21 3171 705]);
dimg = imcrop(dimg,[711 21 3171 705]);
[H W Ch] = size(simg);
for jj = 1:1:600

    stIdxH = randi(H-patchHW(1));
    stIdxW = randi(H-patchHW(2));
    spatch = simg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :);
    dpatch = dimg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :);
    imwrite(spatch, [dloc 'train\' num2str(51)  '_' num2str(jj) '_' '.bmp'], 'bmp');
    imwrite(dpatch, [dloc 'labels\' num2str(51) '_' num2str(jj) '_' '.bmp'], 'bmp');
end
   
%end
