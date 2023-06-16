clc; clear; close all;

rng('shuffle');
disp('Loading the saved model')
load('E:\Datafolder\MS_Research\FCN_SementicSeg\models_saved\FCN8s_VGG16.mat', 'net')
%load('D:\Rashid Data\models\savedCNN_unbalance\', 'convnet', 'TR')

%dloc = 'D:\Rashid Data\FCN_SementicSeg\results_data\fcn8_vgg16\';% destination Classified images
dloc = 'E:\Datafolder\MS_Research\FCN_SementicSeg\results_data\'
loc = 'E:\Datafolder\MS_Research\dataset\Bleed-Through Database Images Update\testing\'; %read from location 
%list = dir([loc '*.bmp']);
list = dir([loc '*.tif']);

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
            
%             rm = mean(spatch(:,1)); 
%             gm = mean(spatch(:,2));
%             bm = mean(spatch(:,3));
%             spatch(:,1) = spatch(:,1)-rm;
%             spatch(:,2) = spatch(:,2)-gm;
%             spatch(:,3) = spatch(:,3)-bm;
            result = semanticseg(spatch,net);
            %result = labeloverlay(spatch,result,'IncludedLabels',"text",'Colormap','white');
            result = labeloverlay(spatch,result);
            dimg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :) = result;
            
            jj = jj + 1;  
            npatches = npatches + 1;
        end        
    end
    imwrite(dimg, [dloc  num2str(ii)  '_FCN_custom' '.bmp'], 'bmp');
end
