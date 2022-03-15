% GET_FEATURES: Extracting hierachical convolutional features

function feat = get_features(im, cos_window, layers,params)

sz_window = size(cos_window);

% Preprocessing
img = single(im);        % note: [0, 255] range

img = imResample(img, params.net.meta.normalization.imageSize(1:2));
% img = imResample(img, net.normalization.imageSize(1:2));

average=params.net.meta.normalization.averageImage;
% average=net.normalization.averageImage;


if numel(average)==3
    average=reshape(average,1,1,3);
end

img = bsxfun(@minus, img, average);

if params.enableGPU, img = gpuArray(img); end

% Run the CNN
res = vl_simplenn(params.net,img);

% Initialize feature maps
feat = cell(length(layers), 1);

for ii = 1:length(layers)
    
    % Resize to sz_window
    if params.enableGPU
        x = gather(res(layers(ii)).x); 
    else
        x = res(layers(ii)).x;
    end
    

    
    x = imResample(x, sz_window(1:2));
    
    % windowing technique
    if ~isempty(cos_window),
        x = bsxfun(@times, x, cos_window);
    end
    
    feat{ii}=x;
end

end
