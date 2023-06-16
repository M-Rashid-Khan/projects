clc; clear; close all;

%digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', 'nndatasets','DigitDataset');
digitDatasetPath = 'D:\Rashid Data\AnncientImages\extracted_dataset1\coarse samples\coarse images-refined\';    
digitData = imageDatastore(digitDatasetPath, 'IncludeSubfolders',true,'LabelSource','foldernames');

% CountLabel = digitData.countEachLabel;
% trainingNumFiles = ceil(min(CountLabel.Count)*0.80);
% rng('default') % For reproducibility, use constant like 1
%[trainDigitData,valDigitData] = splitEachLabel(digitData,trainingNumFiles,'randomize');
[trainDigitData,valDigitData, testDigitData] = splitEachLabel(digitData,0.7,0.15,0.15,'randomize');

% net.divideParam.trainRatio = 80/100;
% net.divideParam.valRatio = 20/100;
% net.divideParam.testRatio = 0/100;


save('D:\Rashid Data\CNN\DataSaved\','testDigitData');

%% Training CNN for Urdu Digit Recognition
       
augCellArray = {'randcrop' , 'randfliplr'};
layers = [imageInputLayer([64 64 3], 'DataAugmentation', augCellArray) % , 'DataAugmentation', 'randfliplr' 
          convolution2dLayer(5, 32)
          reluLayer
          maxPooling2dLayer(2,'Stride',2)
          convolution2dLayer(5, 64)
          reluLayer
          maxPooling2dLayer(2,'Stride',2)
          convolution2dLayer(5, 64)
          reluLayer
          fullyConnectedLayer(100)
          reluLayer
          fullyConnectedLayer(4)
          softmaxLayer
          classificationLayer()];

options = trainingOptions('sgdm',...
    'LearnRateSchedule','piecewise',...
    'InitialLearnRate',0.001, ...
    'LearnRateDropFactor',0.2,...
    'LearnRateDropPeriod',5,...
    'MaxEpochs',30,...
    'MiniBatchSize',32,...
    'Plots','training-progress');
    %'ValidationData', valDigitData 
    %'OutputFcn',@(info)stopIfAccuracyNotImproving(info,3));
%     'CheckpointPath','D:\Rashid Data\CNN\09022020\checkpoints\');


%analyzeNetwork(layers)
[convnet, TR] = trainNetwork(trainDigitData,layers,options);
disp('Training Fininshed');
YTest = classify(convnet,testDigitData);
TTest = testDigitData.Labels;
accuracy = sum(YTest == TTest)/numel(TTest);

save('D:\Rashid Data\CNN\26022020\CNN2', 'convnet', 'TR','YTest','TTest');

%% Stops If Accuracy Not Improving
%%plz include 'OutputFcn',@(info)stopIfAccuracyNotImproving(info,3) in
%%options
function stop = stopIfAccuracyNotImproving(info,N)

stop = false;

% Keep track of the best validation accuracy and the number of validations for which
% there has not been an improvement of the accuracy.
persistent bestValAccuracy
persistent valLag

% Clear the variables when training starts.
if info.State == "start"
    bestValAccuracy = 0;
    valLag = 0;
    
elseif ~isempty(info.ValidationLoss)
    
    % Compare the current validation accuracy to the best accuracy so far,
    % and either set the best accuracy to the current accuracy, or increase
    % the number of validations for which there has not been an improvement.
    if info.ValidationAccuracy > bestValAccuracy
        valLag = 0;
        bestValAccuracy = info.ValidationAccuracy;
    else
        valLag = valLag + 1;
    end
    
    % If the validation lag is at least N, that is, the validation accuracy
    % has not improved for at least N validations, then return true and
    % stop training.
    if valLag >= N
        stop = true;
    end
    
end

end
