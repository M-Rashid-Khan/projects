matconvnet_path = 'D:\Rashid Data\matconvnet-1.0-beta25';
setupMatConvNet(matconvnet_path);
% load and preprocess an image
im = imread('D:\Rashid Data\data\cifar10\cifar10Test\deer\image37.png') ;
im_ = imresize(single(im), net.meta.normalization.imageSize(1:2)) ;
im_ = im_ - net.meta.normalization.averageImage;
% run the CNN
res = vl_simplenn(net, im_) ;
% show the classification result
scores = squeeze(gather(res(end).x)) ;
[bestScore, best] = max(scores) ;
title(sprintf('%s (%d), score %.3f',...
net.meta.classes.description{best}, best, bestScore)) ;