close all;
clear all; 
clc
outputFolder = 'E:\Datafolder\MS_Research\dataset\Bleed-Through Database Images Update';

imgDir = fullfile(outputFolder,'train');
labelDir = fullfile(outputFolder,'labels');
imds = imageDatastore(imgDir);
I = readimage(imds,75);
I = histeq(I);
% figure;
% imshow(I)

classes = ["background","text"];
labelIDs = [255 0];
labelDir = fullfile(outputFolder,'labels');
pxds = pixelLabelDatastore(labelDir,classes,labelIDs);

C = readimage(pxds,75);
%cmap = camvidColorMap;
cmap = [1 1 1
    0 0 0];
B = labeloverlay(I,C,'ColorMap',cmap);
% figure;
% imshow(B)
pixelLabelColorbar(cmap,classes);

tbl = countEachLabel(pxds);
frequency = tbl.PixelCount/sum(tbl.PixelCount);

% bar(1:numel(classes),frequency)
% xticks(1:numel(classes)) 
% xticklabels(tbl.Name)
% xtickangle(45)
ylabel('Frequency')
% loads VGG16 based fcn layers 
imageSize = [224 224];
numClasses = numel(classes);
lgraph = fcnLayers(imageSize,numClasses);

imageFreq = tbl.PixelCount ./ tbl.ImagePixelCount;
classWeights = median(imageFreq) ./ imageFreq;

pxLayer = pixelClassificationLayer('Name','labels','Classes',tbl.Name,'ClassWeights',classWeights);

lgraph = removeLayers(lgraph,'pixelLabels');
lgraph = addLayers(lgraph, pxLayer);
lgraph = connectLayers(lgraph,'softmax','labels');
%analyzeNetwork(lgraph)
options = trainingOptions('sgdm', ...
    'InitialLearnRate',1e-4, ...
    'MaxEpochs',100, ...  
    'MiniBatchSize',4, ...
    'Shuffle','every-epoch', ...
    'CheckpointPath', 'D:\Rashid Data\FCN_SementicSeg\checkpoints_FCN8_VGG16\', ...
    'VerboseFrequency',2);

pximds = pixelLabelImageDatastore(imds,pxds);
[net, info] = trainNetwork(pximds,lgraph,options);

save('E:\Datafolder\MS_Research\FCN_SementicSeg\models_saved\FCN_8_03Dec2021.mat','net','info');


function pixelLabelColorbar(cmap, classNames)
% Add a colorbar to the current axis. The colorbar is formatted
% to display the class names with the color.

colormap(gca,cmap)

% Add colorbar to current figure.
c = colorbar('peer', gca);

% Use class names for tick marks.
c.TickLabels = classNames;
numClasses = size(cmap,1);

% Center tick labels.
c.Ticks = 1/(numClasses*2):1/numClasses:1;

% Remove tick mark.
c.TickLength = 0;
end