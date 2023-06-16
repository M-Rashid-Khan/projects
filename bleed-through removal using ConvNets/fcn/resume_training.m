%resume training

close all;
clear all; 
clc
outputFolder = 'D:\Rashid Data\AnncientImages\extracted_dataset6\';

load('D:\Rashid Data\FCN_SementicSeg\checkpoints_FCN_VGG16\net_checkpoint__49782__2020_02_02__02_34_44.mat', 'net')
imgDir = fullfile(outputFolder,'train');
labelDir = fullfile(outputFolder,'labels');
imds = imageDatastore(imgDir);

classes = ["background","text"];
labelIDs = [255 0];
labelDir = fullfile(outputFolder,'labels');
pxds = pixelLabelDatastore(labelDir,classes,labelIDs);



imageSize = [224 224];
numClasses = numel(classes);

options = trainingOptions('adam', ...
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',7, ...  
    'MiniBatchSize',4, ...
    'Shuffle','every-epoch', ...
    'CheckpointPath', 'D:\Rashid Data\FCN_SementicSeg\checkpoints_FCN_VGG16\', ...
    'VerboseFrequency',2,...
    'Plots','training-progress');
lgraph = layerGraph(net);
pximds = pixelLabelImageDatastore(imds,pxds);
[net2, info] = trainNetwork(pximds,lgraph,options);

save('FCN8s_VGG16.mat','net2');