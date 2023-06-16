clc; clear; close all;

rng('shuffle');
disp('Loading the saved model')
load('D:\Rashid Data\models\trainedCNN\', 'convnet', 'TR')
dloc = 'D:\Rashid Data\results\CNN_Classified\';% destination Classified images
dloc2 = 'D:\Rashid Data\results\CNN_Classified\cropped_images\'; %cropped images destination
loc = 'D:\Rashid Data\datasets\AnncientImages\images\'; %read from location 
list = dir([loc '*.bmp']);

patchHW = [64 64];
jj = 1;
% I = imread('cameraman.tif');
% [J, rect] = imcrop(I);
for ii = 1:1:length(list)
    
    fprintf('Processing the image #: %d\n', ii);
    %fprintf('Processing the image\n');
    %simg = imread(loc);
    img_name = list(ii).name;
    %img_name = list(1).name;
    I = imread([loc img_name]);

    simg = imcrop(I);
    %imwrite(simg, [dloc  num2str(1)  '_' '.bmp'], 'bmp');
    imwrite(simg, [dloc2  num2str(ii)  '_' '.bmp'], 'bmp');
    list2 = dir([dloc2 '*.bmp']);
    img2_name = list2(ii).name;
    %dimg = imread(['D:\Rashid Data\datasets\AnncientImages\GroundTruth_Imgs\' list(ii).name]);
    [H W Ch] = size(simg);

    strideH = 8;
    strideW = 8;
    img2= imread([dloc2 img2_name]);
    for hCtr = 1:strideH:H-patchHW(1)
        for wCtr = 1:strideW:W-patchHW(2)
            stIdxH = hCtr; 
            stIdxW = wCtr; 
            spatch = simg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :);
            %dpatch = dimg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :);
            result = classify(convnet,spatch);
            if result == 'background_only'| 'bleedthrough_text'
                %disp('read the image in CNN_classified and write that patch as white patch')
                img2(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :) = 255;
                imwrite(img2, [dloc  num2str(ii)  '_' '.bmp'], 'bmp');
            end
            jj = jj + 1;            
        end
    end

end
