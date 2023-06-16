clc; clear; close all;

rng('shuffle');
dloc = 'E:/Datafolder/MS_Research/dataset/Bleed-Through Database Images Update/rgb/';
oloc = 'E:/Datafolder/MS_Research/dataset/Bleed-Through Database Images Update/';
%dloc = 'E:/Datafolder/MS_Research/datasetBleed-Through Database Images Update/gs/';
gloc = 'E:/Datafolder/MS_Research/dataset/Bleed-Through Database Images Update/gt/';
list = [dir([dloc '*.bmp']); dir([dloc '*.tif'])];
list2 = [dir([gloc '*.bmp']); dir([gloc '*.tif'])];
patchHW = [64 64];
jj = 1;
for ii = 1:1:length(list)
    fprintf('Processing the image #: %d\n', ii);
    simg = imread([dloc list(ii).name]);
    dimg = imread([gloc list2(ii).name]);
    [H, W, Ch] = size(simg);
    
    stride = 16;
    for hCtr = 1:stride:H-patchHW(1)
        for wCtr = 1:stride:W-patchHW(2)
            stIdxH = hCtr; 
            stIdxW = wCtr; 
            spatch = simg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :);
            dpatch = dimg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :);
            imwrite(spatch, [oloc 'train\' num2str(ii)  '_' num2str(jj) '_' '.png'], 'png');
            imwrite(dpatch, [oloc 'labels\' num2str(ii) '_' num2str(jj) '_' '.png'], 'png');
            jj = jj + 1;            
        end
    end
   
end
