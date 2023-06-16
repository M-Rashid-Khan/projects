clc; clear; close all;

rng('shuffle');

dloc = 'D:\Rashid Data\AnncientImages\extracted_dataset4\';
loc = 'D:\Rashid Data\AnncientImages\images\';
list = dir([loc '*.bmp']);

patchHW = [50 50];
jj = 1;
for ii = 1:1:length(list)
    
    fprintf('Processing the image #: %d\n', ii);
    simg = imread([loc list(ii).name]);
    dimg = imread(['D:\Rashid Data\AnncientImages\GroundTruth_Imgs\' list(ii).name]);
    [H W Ch] = size(simg);
    
    stride = 8;
    for hCtr = 1:stride:H-patchHW(1)
        for wCtr = 1:stride:W-patchHW(2)
            stIdxH = hCtr; 
            stIdxW = wCtr; 
            spatch = simg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :);
            dpatch = dimg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :);
            imwrite(spatch, [dloc 'train\' num2str(ii)  '_' num2str(jj) '_' '.bmp'], 'bmp');
            imwrite(dpatch, [dloc 'labels\' num2str(ii) '_' num2str(jj) '_' '.bmp'], 'bmp');
            jj = jj + 1;            
        end
    end
   
end
