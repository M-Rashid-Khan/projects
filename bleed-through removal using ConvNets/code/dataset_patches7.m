clc; clear; close all;

rng('shuffle');
%dloc = 'E:\Datafolder\MS_Research\dataset\Bleed-Through Database Images Update\rgb\';
%oloc = 'E:\Datafolder\MS_Research\dataset\Bleed-Through Database Images Update/';
oloc = 'E:\Datafolder\MS_Research\dataset\Bleed-Through Database Images Update\AnncientImages/';
dloc = 'E:\Datafolder\MS_Research\dataset\Bleed-Through Database Images Update\AnncientImages/';
%gloc = 'E:\Datafolder\MS_Research\dataset\Bleed-Through Database Images Update\AnncientImages/gt/';
gloc = 'E:\Datafolder\MS_Research\dataset\Bleed-Through Database Images Update\AnncientImages/seg/';
%gloc = 'E:\Datafolder\MS_Research\dataset\Bleed-Through Database Images Update\gt\';


%list = dir([dloc '*.bmp']);
list2 = dir([gloc '*.bmp']);
patchHW = [224 224];
jj = 1;
for ii = 1:1:length(list2)
    fprintf('Processing the image #: %d\n', ii);
    %simg = imread([dloc list(ii).name]);
    dimg = imread([gloc list2(ii).name]);
    [H, W, Ch] = size(dimg);
    
    stride = 64;
    for hCtr = 1:stride:H-patchHW(1)
        for wCtr = 1:stride:W-patchHW(2)
            stIdxH = hCtr; 
            stIdxW = wCtr; 
            %fprintf('stIdxH %d\n', stIdxH);
            %fprintf("stIdxW %d\n", stIdxW);
            %spatch = simg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :);
            dpatch = dimg(stIdxH:stIdxH+patchHW(1)-1, stIdxW:stIdxW+patchHW(2)-1, :);
            %imwrite(spatch, [oloc 'train\' num2str(ii)  '_' num2str(jj) '_' '.bmp'], 'bmp');
            imwrite(dpatch, [oloc 'labelss\' num2str(ii) '_' num2str(jj) '_' '.bmp'], 'bmp');
            jj = jj + 1;            
        end
    end
   
end
