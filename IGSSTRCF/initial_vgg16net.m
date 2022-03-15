
function initial_vgg16net()
% INITIAL_NET: Loading VGG-Net-16
global vgg16net;

vgg16net = load('/data/home/monika/DPRF_Arjun/vot-toolkit-master_ver5.0.1/workspace/QBACF_tracker/model/imagenet-vgg-verydeep-16.mat');

% Remove the fully connected layers and classification layer
vgg16net.layers(30+1:end) = [];

% Switch to GPU mode
global enableGPU;
if enableGPU     
%     params.gpus=[1 2];
%     prepareGPUs(params, 1) ;
%     params.parameterServer.method = 'mmap' ;
%     params.parameterServer.prefix = 'mcn' ;
%     numGpus = numel(params.gpus) ;
%     if numGpus >= 1
       vgg16net = vl_simplenn_move(vgg16net, 'gpu');
%     end
%     if numGpus > 1
%       parserv = ParameterServer(params.parameterServer) ;
%       vl_simplenn_start_parserv(vgg16net, parserv) ;
%     else
%       parserv = [] ;
%     end
end

vgg16net=vl_simplenn_tidy(vgg16net);
save vgg16net.mat vgg16net
end
% -------------------------------------------------------------------------
