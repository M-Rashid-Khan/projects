clc
clear all;
%testing
dataSetDir = "D:\Rashid Data\AnncientImages\extracted_dataset6\"
testImagesDir = fullfile(dataSetDir,'test_images');
testLabelsDir = fullfile(dataSetDir,'test_labels');
imds = imageDatastore(testImagesDir);

load('D:\Rashid Data\FCN_SementicSeg\models_saved\FCN8s_VGG16.mat', 'net2');
classNames = ["background",'text'];
pixelLabelID = [255 0];
pxdsTruth = pixelLabelDatastore(testLabelsDir,classNames,pixelLabelID);
pxdsResults = semanticseg(imds,net2,"WriteLocation",tempdir,'MiniBatchSize',4);

metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTruth);
metrics.ClassMetrics
metrics.ConfusionMatrix

normConfMatData = metrics.NormalizedConfusionMatrix.Variables;
figure
h = heatmap(classNames,classNames,100*normConfMatData);
h.XLabel = 'Predicted Class';
h.YLabel = 'True Class';
h.Title = 'Normalized Confusion Matrix (%)';
