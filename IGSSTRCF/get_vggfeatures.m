% GET_FEATURES: Extracting hierachical convolutional features

function feat = get_vggfeatures(im, use_sz, layers,params)

% global vgg16net
global enableGPU
% if isempty(vgg16net)
%     initial_vgg16net();
% end
sz_window = use_sz;

% Preprocessing
% img=im;
% im=im/255;
img = single(im);        % note: [0, 255] range
%img = imresize(img, vgg16net.meta.normalization.imageSize(1:2),'bicubic');
img = imResample(img, params.vgg16net.meta.normalization.imageSize(1:2));

average=params.vgg16net.meta.normalization.averageImage;

if numel(average)==3
    average=reshape(average,1,1,3);
end

img = bsxfun(@minus, img, average);

%if enableGPU, img = gpuArray(img);vgg16net = vl_simplenn_move(vgg16net,'gpu'); end
if enableGPU  
        img = gpuArray(img);
%      vgg16net = vl_simplenn_move(params.vgg16net, 'gpu');
end

% Run the CNN
res = vl_simplenn(params.vgg16net,img);

% Initialize feature maps
feat = cell(length(layers), 1);

for ii = 1:length(layers)

    % Resize to sz_window
    if enableGPU
        
        x = res(layers(ii)).x;
      %  x = gather(x);
%        x = imresize(x, sz_window(1:2));
    else
        x = res(layers(ii)).x;
    end
x = gather(x);
%     x=real(x)+abs(min(x(:)))+1;
x = imresize(x, sz_window(1:2),'bicubic');
x=gpuArray(x);
%    x = imResample(x, sz_window(1:2));
  
    % windowing technique
    
    feat{ii}=x;
end
feat=feat{1};

end