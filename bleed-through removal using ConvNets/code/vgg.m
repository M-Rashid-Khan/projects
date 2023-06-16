opts.sourceModelUrl = 'http://www.vlfeat.org/matconvnet/models/imagenet-vgg-verydeep-16.mat' ;
opts.sourceModelPath = 'data/models/imagenet-vgg-verydeep-16.mat' ;
% -------------------------------------------------------------------------
%                    Load & download the source model if needed (VGG VD 16)
% -------------------------------------------------------------------------
if ~exist(opts.sourceModelPath)
  fprintf('%s: downloading %s\n', opts.sourceModelUrl) ;
  mkdir(fileparts(opts.sourceModelPath)) ;
  urlwrite('http://www.vlfeat.org/matconvnet/models/imagenet-vgg-verydeep-16.mat', opts.sourceModelPath) ;
end
net = vl_simplenn_tidy(load(opts.sourceModelPath)) ;

% for convt (deconv) layers, cuDNN seems to be slower?
net.meta.cudnnOpts = {'cudnnworkspacelimit', 512 * 1024^3} ;
%net.meta.cudnnOpts = {'nocudnn'} ;
