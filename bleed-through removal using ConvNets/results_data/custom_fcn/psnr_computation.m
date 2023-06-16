clc; clear all;
gTruthLoc = 'D:\Rashid Data\FCN_SementicSeg\results_data\g_truth\';
fcnCustomLoc = 'D:\Rashid Data\FCN_SementicSeg\results_data\custom_fcn\fcn_output\'; %custom
fcnVggLoc = 'D:\Rashid Data\FCN_SementicSeg\results_data\fcn8_vgg16\fcnVgg\';
Noisy_OriginalLoc= 'D:\Rashid Data\FCN_SementicSeg\results_data\images\';

list = dir([fcnCustomLoc '*.bmp']);

% pairs of gTruth and fcnCustomLoc
for ii=1:1:length(list)
    gtFileName = [gTruthLoc list(ii).name];
    fcnFileName = [Noisy_OriginalLoc list(ii).name];
    gtImg = imread(gtFileName);
    fcnImg = imread(fcnFileName);
%     gtImg = rgb2gray(gtImg);
%     fcnImg = rgb2gray(fcnImg);

    [~,~,Cgt] = size(gtImg);
    if Cgt > 1
        gtImg = rgb2gray(gtImg);
    end
    
    [~,~,Cfn] = size(fcnImg);    
    if Cfn > 1
        fcnImg = rgb2gray(fcnImg);
    end    
    
    [peaksnr, snr] = psnr(fcnImg, gtImg);  
    fprintf('\n The Peak-SNR value is %0.4f, snr: %f\n', peaksnr, snr);
    err = immse(fcnImg, gtImg);
    fprintf('\n The mean-squared error is %0.4f\n', err);
    [ssimval,ssimmap] = ssim(fcnImg,gtImg);
    fprintf('\n The Global SSIM Value is %0.4f\n', ssimval);
end