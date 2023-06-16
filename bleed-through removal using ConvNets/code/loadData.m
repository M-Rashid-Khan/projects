%digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', 'nndatasets','DigitDataset');
digitDatasetPath = 'D:\Rashid Data\AnncientImages\extracted_dataset\coarse label-refined\';    
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
trainingNumFiles = ceil(min(CountLabel.Count)*0.80);
rng('default') % For reproducibility, use constant like 1
[trainDigitData,testDigitData] = splitEachLabel(digitData, ...
				trainingNumFiles,'randomize');
save('D:\Rashid Data\AnncientImages\extracted_dataset\', 'testDigitData')
