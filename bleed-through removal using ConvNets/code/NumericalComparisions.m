clear all 
clc

%GTimgs = dir('IMAGES\Hanif-ColorSegment_results\GT_Images\*.tif');\
GTimgs = dir('E:\Datafolder\MS_Research\comparison\gt\*.bmp');
%RestImgSet = dir('IMAGES\Hanif-ColorSegment_results\HanifComparsionWithCRF\*.bmp');  % the folder in which ur images exists
RestImgSet = dir('E:\Datafolder\MS_Research\comparison\segmented\*.bmp');

%CRFImgSet = dir('IMAGES\Hanif-ColorSegment_results\CRF_RestImg\*.jpg'); 
%CRF_GTImgs = dir('IMAGES\Hanif-ColorSegment_results\CRF_GT_Images\*.tif'); 

for i = 1 : length(RestImgSet)
    filename = RestImgSet(i).name; % strcat('E:\New Folder\',srcFiles(i).name);
    
    %RestImg = imread(strcat('IMAGES\Hanif-ColorSegment_results\HanifComparsionWithCRF\',filename));
    RestImg = imread(strcat('E:\Datafolder\MS_Research\comparison\segmented\',filename));
    RestImg = rgb2gray(RestImg);
    %figure, imshow(RestImg);title('HanifRest');
    
%     RestImgBi=sauvola(RestImg);
     %figure, imshow(RestImgBi);
     %figure, imshow(RestImg);
%     
%     RestImgBi2 = imbinarize(RestImg);
%     figure, imshow(RestImgBi2);
    
    RestImgBi = im2bw(RestImg,graythresh(RestImg));
    
    %RestImgBi = sauvola(RestImg);%,graythresh(RestImg));
    %figure, imshow(RestImgBi);
    %ll = length(filename);
    FN2=filename(1:length(filename)-4);
    %GTimgName = strcat(FN2,'.gt.tif');
    GTimgName = strcat(FN2,'.bmp');
    GTImg = imread(strcat('E:\Datafolder\MS_Research\comparison\gt\',GTimgName));
    %GTImg = imread(strcat('E:\Datafolder\MS_Research\comparison\gt\',GTimgName));
    %figure, imshow(GTImg);title('HanifGT');
    GTImg = rgb2gray(GTImg);
    %figure, imshow(GTImg);title('HanifGT');
    
    PixlDetct_Hanif = sum(GTImg == 0 & RestImgBi == 0);
    
PreHanif(i) = PixlDetct_Hanif/sum(RestImgBi == 0);
RecallHanif(i) = PixlDetct_Hanif/sum(GTImg==0);
Fmeasur_Hanif(i) = (2*RecallHanif(i)*PreHanif(i))/(RecallHanif(i)+PreHanif(i));
%Hanif_ImgQuality(i) = computeQualityMetrics(RestImg);
    
%CRFname = CRFImgSet(i).name; % strcat('E:\New Folder\',srcFiles(i).name);
    %CRFImg = imread(strcat('IMAGES\Hanif-ColorSegment_results\CRF_RestImg\',FN2,'.CRF.jpg'));
    %figure, imshow(CRFImg);title('CRFImg');
  %CRFImgBi = im2bw(CRFImg,graythresh(CRFImg));
  
   %CRFImgBi = sauvola(CRFImg);%,graythresh(CRFImg));
%FN3=CRFname(1:length(CRFname)-3);
   % CRF_GTimgName = strcat(FN2,'.gt.tif');
   %  CRF_GTImg = imread(strcat('IMAGES\Hanif-ColorSegment_results\CRF_GT_Images\',CRF_GTimgName));
    %figure, imshow(CRF_GTImg);title('CRF_GTImg');
     
    % PixlDetct_CRF = sum(CRF_GTImg == 0 & CRFImgBi == 0);
%PreCRF(i) = PixlDetct_CRF/sum(CRFImgBi == 0);
%RecallCRF(i) = PixlDetct_CRF/sum(CRF_GTImg==0);
%Fmeasur_CRF(i) = (2*RecallCRF(i)*PreCRF(i))/(RecallCRF(i)+PreCRF(i));
    
end



Fmeasure_CRFavg = sum(Fmeasur_CRF)/length(Fmeasur_CRF);
Precision_CRFavg = sum(PreCRF)/length(PreCRF);
Recall_CRFavg = sum(RecallCRF)/length(RecallCRF);

Fmeasure_Hanifavg = sum(Fmeasur_Hanif)/length(Fmeasur_Hanif);
Precision_Hanifavg = sum(PreHanif)/length(PreHanif);
Recall_Hanifavg = sum(RecallHanif)/length(RecallCRF);


Hanif_ImgQuality = computeQualityMetrics(RestImg);


% 
% % Get list of all BMP files in this directory
% % DIR returns as a structure array.  You will need to use () and . to get
% % the file names.
% imagefiles = dir('*.bmp');      
% nfiles = length(imagefiles);    % Number of files found
% for ii=1:nfiles
%    currentfilename = imagefiles(ii).name;
%    currentimage = imread(currentfilename);
%    images{ii} = currentimage;
% end
% 
% 
% 
% 
% imageSet={'RIA.MSCiii3.420v.rgb','TCD.1436.81.rgb','TCD.1436.82.rgb','TCD.MS1333.9.rgb',...
%     'TCD.MS1333.10.rgb','TCD.MS1343.59.rgb','TCD.MS1343.60.rgb','TCD.MS1435.147.rgb',...
%     'TCD.MS1435.148.rgb','UCD.AddIM14.386.rgb','UCD.AddIM14.387.rgb','UCD.AddIM14.726.rgb',...
%     'UCD.AddIM14.727.rgb','UCD.MSA13.xxv.rgb','UCD.MSA13.xxvi.rgb','UCD.MSA15.5.rgb','UCD.MSA15.6.rgb',...
%     'UCD.MSA15.37.rgb','UCD.MSA15.38.rgb','UCD.MSA20.127r.rgb','UCD.MSA20.127v.rgb','UCD.MSA29.12r.rgb',...
%     'UCD.MSA29.12v.rgb','UCD.MSA29.119r.rgb','UCD.MSA29.119v.rgb','UCD.MSA29.121r.rgb','UCD.MSA29.121v.rgb',...
%     'UCD.MSA33.87.rgb','UCD.MSA33.88.rgb'};
% 
% 
% for a = 1:10
%    filename = ['user001-' num2str(a,'%02d') '.bmp'];
%    img = imread(filename);
%    % do something with img
% end
% 
% 
% for ii=1:nfiles
%    currentfilename = imagefiles(ii).name;
%    currentimage = imread(currentfilename);
%    images{ii} = currentimage;
% end
% 
% PixlDetct_crf=sum(FgTxtOLD==0 & crfRest==0);
% PreCRF = PixlDetct_crf/sum((crfRest ==0));
% RecallCRF = PixlDetct_crf/sum((FgTxtOLD ==0));
% Fmeasur_CRF = (2*RecallCRF*PreCRF)/(RecallCRF+PreCRF);
% 
% PixlDetct_Hanif=sum(Gtimg==0 & (~RestImg)==0);
% PreHanif = PixlDetct_Hanif/sum(RestImg ==1);
% RecallHanif = PixlDetct_Hanif/sum(Gtimg==0);
% Fmeasur_Hanif = (2*RecallHanif*PreHanif)/(RecallHanif+PreHanif);