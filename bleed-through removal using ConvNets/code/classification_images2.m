clc; clear; close all;

rng('shuffle');
disp('Loading the saved model')
% load('D:\Rashid Data\CNN\09022020\09022020_saved_model.mat', 'net')
load('D:\Rashid Data\CNN\09022020\CNN_2.mat', 'convnet')

dloc = 'D:\Rashid Data\CNN\09022020\results\';% destination Classified images
loc = 'D:\Rashid Data\AnncientImages\images\'; %read from location 
list = dir([loc '*.bmp']);

patchHW = [64 64];
jj = 1;

for ii = 1:1:length(list)
    
    fprintf('Processing the image #: %d\n', ii);
    simg = imread([loc list(ii).name]); 
    %simg = im2double(simg);
    [H W Ch] = size(simg);
    dimg = simg; %zeros([H W Ch]);
    strideH = 32;
    strideW = 32;
    npatches = 1;
    counters = zeros([1 4]);
    for hCtr = 1:strideH:H-patchHW(1)
        for wCtr = 1:strideW:W-patchHW(2)
            stIdxH = hCtr; 
            stIdxW = wCtr; 
            spatch = simg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :);
            
            rm = mean(spatch(:,1)); 
            gm = mean(spatch(:,2));
            bm = mean(spatch(:,3));
            spatch(:,1) = spatch(:,1)-rm;
            spatch(:,2) = spatch(:,2)-gm;
            spatch(:,3) = spatch(:,3)-bm;
%             result = semanticseg(spatch,net);
%             result = labeloverlay(testImage,C);
            result = classify(convnet,spatch);
            
            if result == 'bleedthrough_text'
                %dimg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :) = 255;
                %imwrite(simg, [dloc  num2str(ii)  '_' '.bmp'], 'bmp');
                counters(1) = counters(1) + 1;
            elseif result == 'background_only'
                dimg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :) = 255;
                %imwrite(dimg, [dloc  num2str(ii)  '_' '.bmp'], 'bmp');
                counters(2) = counters(2) + 1;
            elseif result == 'bleedthrough_only'
                dimg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :) = 255;
                %imwrite(dimg, [dloc  num2str(ii)  '_' '.bmp'], 'bmp');                            
                counters(3) = counters(3) + 1;
            elseif result == 'text_only'
                %dimg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :) = 255;
                %imwrite(simg, [dloc  num2str(ii)  '_' '.bmp'], 'bmp');
                counters(4) = counters(4) + 1;
            end
            jj = jj + 1;  
            npatches = npatches + 1;
        end        
    end
    imwrite(dimg, [dloc  num2str(ii)  '_' '.bmp'], 'bmp');
end
