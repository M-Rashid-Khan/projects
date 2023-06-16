clc
clear all;
%% Load Data
dataSetDir  = fullfile('D:\Rashid Data\AnncientImages\extracted_dataset4\');
imageDir  = fullfile(dataSetDir,'train');
labelDir  = fullfile(dataSetDir,'label');

imds = imageDatastore(imageDir);
classNames = ["background",'text'];
pixelLabelID = [255 0];
pxds = pixelLabelDatastore(labelDir,classNames,pixelLabelID);

%% Input Layer
inputSize = [64 64 3];
imgLayer = imageInputLayer(inputSize)


%%
numClasses = 2;
filterSize = 3;
numFilters = 64;
poolSize = 2;
conv = convolution2dLayer(filterSize,numFilters,'Padding',1);
relu = reluLayer();
maxPoolDownsample2x = maxPooling2dLayer(poolSize,'Stride',2); 
transposedConvUpsample2x = transposedConv2dLayer(4,numFilters,'Stride',2,'Cropping',1);
conv1x1 = convolution2dLayer(1,numClasses);

%% DownSapmpling Network
downsamplingLayers = [
    conv
    relu
    maxPoolDownsample2x
    conv
    relu
    maxPoolDownsample2x
    ];
%% Upsampling Network
upsamplingLayers = [
    transposedConvUpsample2x
    relu
    transposedConvUpsample2x
    relu
    ];
%% A Pixel Classification Layer
finalLayers = [
    conv1x1
    softmaxLayer()
    pixelClassificationLayer()
    ];
%% Stacking All Layers
layers = [
    imgLayer    
    downsamplingLayers
    upsamplingLayers
    finalLayers
    ]
disp('all set');
%% Train A Semantic Segmentation Network