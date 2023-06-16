dataSetDir  = fullfile('D:\Rashid Data\AnncientImages\extracted_dataset6\');
imageDir  = fullfile(dataSetDir,'test_images');
labelDir  = fullfile(dataSetDir,'test_labels');
imds = imageDatastore(imageDir);
classNames = ["background",'text'];
pixelLabelID = [255 0];
pxdsTruth = pixelLabelDatastore(labelDir,classNames,pixelLabelID);
net = load('D:\Rashid Data\FCN_SementicSeg\models_saved\FCN8s_VGG16.mat' , 'net2','TR');
net = net.net2;
pxdsResults = semanticseg(imds,net,"WriteLocation",tempdir,'MiniBatchSize',4);
metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTruth);
metrics.ClassMetrics
metrics.ConfusionMatrix

normConfMatData = metrics.NormalizedConfusionMatrix.Variables;
figure
set(0, 'DefaultAxesFontName', 'Times new roman')
h = heatmap(classNames,classNames,100*normConfMatData);
h.XLabel = 'Predicted Class';
h.YLabel = 'True Class';
%h.Title = 'Normalized Confusion Matrix (%)';
saveas(h,'Normalized_Confusion_matrix_vgg16.png')

imageIoU = metrics.ImageMetrics.MeanIoU;
figure
set(0, 'DefaultAxesFontName', 'Times new roman')
a= histogram(imageIoU)
%title('Image Mean IoU')
saveas(a,'Image Mean IoU VGG16.png');