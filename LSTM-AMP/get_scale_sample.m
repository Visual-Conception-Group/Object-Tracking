function [out out1] = get_scale_sample(im, pos, base_target_sz, scaleFactors, scale_window, scale_model_sz,angl)

% out = get_scale_sample(im, pos, base_target_sz, scaleFactors, scale_window, scale_model_sz)
% 
% Extracts a sample for the scale filter at the current
% location and scale.

nScales = length(scaleFactors);
xx=0; 
for s = 1:nScales
    patch_sz = floor(base_target_sz * scaleFactors(s));
    
    xs = floor(pos(2)) + (1:patch_sz(2)) - floor(patch_sz(2)/2);
    ys = floor(pos(1)) + (1:patch_sz(1)) - floor(patch_sz(1)/2);
    
    % check for out-of-bounds coordinates, and set them to the values at
    % the borders
    xs(xs < 1) = 1;
    ys(ys < 1) = 1;
    xs(xs > size(im,2)) = size(im,2);
    ys(ys > size(im,1)) = size(im,1);
    
    % extract image
    im_patch = im(ys, xs, :);
    

%     
    for count=1:length(angl)
        xx=xx+1;
       im_patch = im(ys, xs, :);
       myimg=imrotate(im_patch,angl(count));
       c1=round(size(myimg,1)/2);
       c2=round(size(myimg,2)/2);
       p1=round(size(im_patch,1)/2);
       p2=round(size(im_patch,2)/2);
       r(1)=c2-p2;
       r(2)=c1-p1;
       r(3)=size(im_patch,2)-1;
       r(4)=size(im_patch,1)-1;
       myimg=imcrop(myimg,[r(1) r(2) r(3) r(4)]);
       
%   
    im_patch_resized = imResample(myimg, scale_model_sz);
    
    % extract scale features
    temp_hog = fhog(single(im_patch_resized), 4);
    temp = temp_hog(:,:,1:31);
    
    if s == 1
        out1 = zeros(numel(temp), nScales, 'single');
    end
    
    % window
    out1(:,xx) = temp(:) * scale_window(s); 
    end %
    %==============================================================
    im_patch = im(ys, xs, :);
    % resize image to model size
    im_patch_resized = imResample(im_patch, scale_model_sz);
    
    % extract scale features
    temp_hog = fhog(single(im_patch_resized), 4);
    temp = temp_hog(:,:,1:31);
    
    if s == 1
        out = zeros(numel(temp), nScales, 'single');
    end
    
    % window
    out(:,s) = temp(:) * scale_window(s); 
     %out(:,xx) = temp(:) * scale_window(s); 
     end 
end





