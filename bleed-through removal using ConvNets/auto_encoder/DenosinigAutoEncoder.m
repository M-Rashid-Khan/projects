net = denoisingNetwork('DnCNN');
I = imread('cameraman.tif');
noisyI = imnoise(I,'gaussian',0,0.01);
montage({I,noisyI})
title('Original Image (Left) and Noisy Image (Right)')
denoisedI = denoiseImage(noisyI,net);
imshow(denoisedI)
title('Denoised Image')


%% Training the denoising auto encoder
% pristine (original) images
digitDatasetPath = fullfile(matlabroot,'toolbox','nnet', ...
    'nndemos','nndatasets','DigitDataset');
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

imds.ReadSize = 500;
rng('default');
imds = shuffle(imds);
[imdsTrain,imdsVal,imdsTest] = splitEachLabel(imds,0.95,0.025);

% Noisy images