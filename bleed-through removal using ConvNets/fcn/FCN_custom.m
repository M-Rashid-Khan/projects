clc
clear all;

%% Load Data
dataSetDir  = fullfile('D:\Rashid Data\AnncientImages\dataset_bleedthrough\Bleed-Through Database Images Update\');
imageDir  = fullfile(dataSetDir,'train_custom');
labelDir  = fullfile(dataSetDir,'labels_custom');
imds = imageDatastore(imageDir);
classNames = ["background",'text'];
pixelLabelID = [255 0];
pxds = pixelLabelDatastore(labelDir,classNames,pixelLabelID);
%% Training Data
trainingData = pixelLabelImageDatastore(imds,pxds);

%% Network Parameter
numFilters = [64,128,256,512,1024];
filterSize = 3;
numClasses = 2;

%% Layers
layers = [
    imageInputLayer([64 64 3])
    convolution2dLayer(filterSize,numFilters(1),'Padding','same')
    reluLayer()
    maxPooling2dLayer(2,'Stride',2)% 32x32
    convolution2dLayer(filterSize,numFilters(2),'Padding','same')
    reluLayer()
    maxPooling2dLayer(2,'Stride',2)%16x16
    convolution2dLayer(filterSize,numFilters(3),'Padding','same')
    reluLayer()
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(filterSize,numFilters(5),'Padding','same')
    reluLayer()
    convolution2dLayer(1,numClasses,'Padding','same')
    reluLayer()
    transposedConv2dLayer(2,numClasses,'Stride',2);% 16x16
    reluLayer()
    transposedConv2dLayer(2,numClasses,'Stride',2);% 32x32
    reluLayer()
    transposedConv2dLayer(2,numClasses,'Stride',2);% 64x64
    reluLayer()
    convolution2dLayer(1,numClasses,'Padding','same');
    softmaxLayer()
    pixelClassificationLayer()
    ];
%lgraph = layerGraph(layers );


%% Improve the results and Train Again with these lines
tbl = countEachLabel(trainingData);
totalNumberOfPixels = sum(tbl.PixelCount);
frequency = tbl.PixelCount / totalNumberOfPixels;
classWeights = 1./frequency;
layers(end) = pixelClassificationLayer('Classes',tbl.Name,'ClassWeights',classWeights);

analyzeNetwork(layers)
%% Options
opts = trainingOptions('sgdm', ...
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',10, ...
    'MiniBatchSize',20, ...
    'Plots','training-progress', ...
    'L2Regularization', 0.0016, ...
    'ExecutionEnvironment', 'gpu',...
    'CheckpointPath','D:\Rashid Data\FCN_SementicSeg\checkpoints\');
    %'OutputFcn','TrainingRMSE');
 

%% Network Train
[net, TR ]= trainNetwork(trainingData,layers,opts);

%% Save Netowork Variables
save("D:\Rashid Data\FCN_SementicSeg\models_saved\FCN_custom_new.mat" , 'net','TR');

