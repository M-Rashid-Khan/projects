%% Training CNN for Urdu Digit Recognition

close all;
clear all; clc;

%digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', 'nndatasets','DigitDataset');
digitDatasetPath = 'D:\Rashid Data\AnncientImages\extracted_dataset1\coarse samples\coarse images-refined\';    
digitData = imageDatastore(digitDatasetPath, 'IncludeSubfolders',true,'LabelSource','foldernames');
    
% figure;
% 
% perm = randperm(length(digitData.Labels),20);
% 
% for i = 1:20
%     subplot(4,5,i);
%     imshow(digitData.Files{perm(i)});
% end

CountLabel = digitData.countEachLabel;

trainingNumFiles = ceil(min(CountLabel.Count) * 0.80);

rng('default') % For reproducibility, use constant like 1
[trainDigitData,testDigitData] = splitEachLabel(digitData, ...
				trainingNumFiles,'randomize');
            

layers = [imageInputLayer([28 28 1], 'DataAugmentation', 'none' ) % , 'DataAugmentation', 'randfliplr' 
          convolution2dLayer(5,20)
          reluLayer
          maxPooling2dLayer(2,'Stride',2)
          convolution2dLayer(5,20)
          reluLayer
          maxPooling2dLayer(2,'Stride',2)
          fullyConnectedLayer(10)
          softmaxLayer
          classificationLayer()];

options = trainingOptions('sgdm',...
    'LearnRateSchedule','piecewise',...
    'InitialLearnRate',0.001, ...
    'LearnRateDropFactor',0.2,...
    'LearnRateDropPeriod',5,...
    'MaxEpochs',30,...
    'MiniBatchSize',32);
    %'Plots','training-progress')

% options = trainingOptions('sgdm','MaxEpochs', 20, ...
% 	'InitialLearnRate',0.0001);

[convnet, TR] = trainNetwork(trainDigitData,layers,options);

YTest = classify(convnet,testDigitData);
TTest = testDigitData.Labels;

accuracy = sum(YTest == TTest)/numel(TTest);

save('D:\ResearchWork\BilalUAJK\code_and_db\ClassifyWithCNN\empty\ConvNet11Class', 'convnet', 'TR');