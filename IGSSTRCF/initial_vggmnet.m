
function initial_vggmnet()
% INITIAL_NET: Loading VGG-Net-16

global vggmnet;
vggmnet = load('/data/home/monika/DPRF_Arjun/vot-toolkit-master_ver5.0.1/workspace/QBACF_tracker/model/imagenet-vgg-m-2048.mat');

% Remove the fully connected layers and classification layer
vggmnet.layers(14+1:end) = [];

% Switch to GPU mode
global enableGPU;
if enableGPU
    vggmnet = vl_simplenn_move(vggmnet, 'gpu');
end

vggmnet=vl_simplenn_tidy(vggmnet);
save vggmnet.mat vggmnet

end
