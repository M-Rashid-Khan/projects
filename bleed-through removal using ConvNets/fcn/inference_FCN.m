clc;clear;close all;
load('E:\Datafolder\MS_Research\FCN_SementicSeg\models_saved\FCN8s_VGG16.mat', 'net','TR');
dloc = "E:\Datafolder\MS_Research\FCN_SementicSeg\data\fcn8_vgg16\";
% Single Image Testing
tic
%testImage = rgb2gray(imread('D:\Rashid Data\AnncientImages\dataset_bleedthrough\Bleed-Through Database Images Update\BleedThrough_Identyfied_for_test\test_recto.tif'));
testImage = imread('D:\Rashid Data\AnncientImages\dataset_bleedthrough\Bleed-Through Database Images Update\train_custom\1_34_.png');
C = semanticseg(testImage,net,'MiniBatchSize',4);
B = labeloverlay(testImage,C);
% figure;
% subplot(1,2,1); imshow(testImage)
% subplot(1,2,2); imshow(B)
%imshow(B)
%Testing images 
toc
imwrite(B, 'E:\Datafolder\MS_Research\FCN_SementicSeg\results_data\fcn8_vgg16\FCN.png', 'png');
