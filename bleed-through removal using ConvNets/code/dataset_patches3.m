clc; clear; close all;

rng('shuffle');

dloc = 'D:\Rashid Data\datasets\extracted_dataset\coarse label-refined\background_only\';% destination 
loc = 'D:\Rashid Data\datasets\AnncientImages\megapatches\background_only\'; %read from location 
list = dir([loc '*.bmp']);

patchHW = [64 64];
jj = 1;
for ii = 1:1:length(list)
    
    fprintf('Processing the image #: %d\n', ii);
    %fprintf('Processing the image');
    %simg = imread(loc);
    simg = imread([loc list(ii).name]);
    %dimg = imread(['D:\Rashid Data\datasets\AnncientImages\GroundTruth_Imgs\' list(ii).name]);
    [H W Ch] = size(simg);

    strideH = 8;
    strideW = 16;
    for hCtr = 1:strideH:H-patchHW(1)
        for wCtr = 1:strideW:W-patchHW(2)
            stIdxH = hCtr; 
            stIdxW = wCtr; 
            spatch = simg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :);
            %dpatch = dimg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :);
            imwrite(spatch, [dloc  num2str(ii)  '_' num2str(jj) '_' '.bmp'], 'bmp');
            %imwrite(dpatch, [dloc 'labels\' num2str(ii) '_' num2str(jj) '_' '.bmp'], 'bmp');
            jj = jj + 1;            
        end
    end
   
end
