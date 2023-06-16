clc; clear; close all;

rng('shuffle');

srcLoc = 'D:\Rashid Data\AnncientImages\extracted_dataset\train\'; %read from location 
targetLoc = 'D:\Rashid Data\AnncientImages\extracted_dataset\labels\';% destination Classified images

srcList = dir([srcLoc '*.bmp']);
targetList = dir([targetLoc '*.bmp']);

pH = 64; pW = 64; Ch = 1;
srcImgDB = zeros([pH*pW*Ch length(targetList)]);
targetImgDB = zeros([pH*pW*Ch length(targetList)]);

for ii = 1:1:1000%length(targetList)
   
    srcImgName = [srcLoc srcList(ii).name];    
    targetImgName = [targetLoc targetList(ii).name];
    if ~strcmp(srcList(ii).name, targetList(ii).name)
       continue; 
    end
    
    srcImg = imread(srcImgName);
    targetImg = imread(targetImgName);
    srcImg = im2double(rgb2gray(srcImg));
    targetImg = im2double(rgb2gray(targetImg));
    
    srcImgDB(:, ii) = srcImg(:);
    targetImgDB(:, ii) = targetImg(:);
    
end
srcImgDB=reshape(srcImgDB.',1,[]);
targetImgDB=reshape(targetImgDB.',1,[]);
%AutoEncoder

autoenc = trainAutoencoder(srcImgDB)