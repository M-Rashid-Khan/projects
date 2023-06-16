clc; clear all; close all;
matconvnet_path = 'D:\Rashid Data\matconvnet-1.0-beta25';
setupMatConvNet(matconvnet_path);
%%Pretrained DnCNN 
% net = denoisingNetwork('DnCNN');
% o_img = imread('D:\Rashid Data\AnncientImages\images\1.bmp');
% o_img = im2double(rgb2gray(o_img));
% d_img = denoiseImage(o_img,net);
% montage(o_img,d_img);
% title('Original and Denoised image');
% subplot(1,2,1); imshow(o_img)
% subplot(1,2,2); imshow(d_img)

%%Training DnCNN on own data


% rng('shuffle');
% 
% % srcLoc = 'D:\Rashid Data\AnncientImages\extracted_dataset\train\'; %read from location 
% % targetLoc = 'D:\Rashid Data\AnncientImages\extracted_dataset\labels\';% destination Classified images
% 
srcLoc = 'D:\Rashid Data\AnncientImages\extracted_dataset4\train\'; %read from location 
targetLoc = 'D:\Rashid Data\AnncientImages\extracted_dataset4\labels\';% destination Classified images

srcList = dir([srcLoc '*.bmp']);
targetList = dir([targetLoc '*.bmp']);

%pH = 64; pW = 64; Ch = 1;
pH = 50; pW = 50; Ch = 1;
%srcImgDB = zeros([pH*pW*Ch length(srcList)]);
%targetImgDB = zeros([pH*pW*Ch length(targetList)]);
srcImgDB = zeros([pH,pW,Ch,length(srcList)]);
targetImgDB = zeros([pH,pW,Ch,length(targetList)]);

for ii = 1:1:length(srcList)
   
    srcImgName = [srcLoc srcList(ii).name];    
    targetImgName = [targetLoc targetList(ii).name];
%     if ~strcmp(srcList(ii).name, targetList(ii).name)
%        continue; 
%     end
    
    srcImg = imread(srcImgName);
    srcImg = im2double(rgb2gray(srcImg));
    targetImg = imread(targetImgName);
    targetImg = im2double(rgb2gray(targetImg));
    
    %srcImgDB(:, ii) = srcImg(:);
    %targetImgDB(:, ii) = targetImg(:);
    srcImgDB(:,:,:, ii) = srcImg(:,:,:);
    targetImgDB(:,:,:, ii) = targetImg(:,:,:);
    
end
% digitDatasetPath='D:\Rashid Data\AnncientImages\extracted_dataset3\train\'; %read from location 
% srcImgDB = imageDatastore(digitDatasetPath);
% digitDatasetPath2='D:\Rashid Data\AnncientImages\extracted_dataset3\labels\'; %read from location 
% targetImgDB = imageDatastore(digitDatasetPath2);

layers = dnCNNLayers;

% layer = sequenceInputLayer([64 64 1],'Name','InputSeqLayer');
% lgraph = layerGraph(layers);
% lgraph = replaceLayer(lgraph,'InputLayer',layer);

options = trainingOptions('sgdm', ...
    'LearnRateSchedule','piecewise', ...
    'L2Regularization', 0.0001, ...
    'LearnRateDropFactor',0.2, ...
    'LearnRateDropPeriod',5, ...
    'MaxEpochs',20, ...
    'MiniBatchSize',64, ...
    'Plots','training-progress');

net = trainNetwork(srcImgDB,targetImgDB,layers,options);
disp('Training Done!!');

A= imread('D:\Rashid Data\AnncientImages\images\1.bmp');
B = denoiseImage(A,net)

figure;
subplot(1,2,1); imshow(A)
subplot(1,2,2); imshow(B)

save('D:\Rashid Data\DnCNN\DnCNN_1.mat', 'net', 'srcImgDB');