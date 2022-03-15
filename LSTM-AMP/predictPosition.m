function [pos appearance,avg_wt,appearance_image,appearance_box,past,past_image,past_box,Wt]= predictPosition(feat, pos, indLayers, nweights, cell_size, l1_patch_num, ...
    model_xf , model_alphaf,frame,rect_anno,image_fl,im,rects,target_sz_t,appearance,avg_wt,appearance_image,appearance_box,im_prev,past,net1,Wt)
% ================================================================================
% Compute correlation filter responses at each layer
% ================================================================================
res_layer = zeros([l1_patch_num, length(indLayers)]);
W=[1 0.2 0.2];%
W  = reshape(W,1,1,[]);

past_image=0;
past_box=0;
for ii = 1 : length(indLayers)
    zf = fft2(feat{ii});
    kzf=sum(zf .* conj(model_xf{ii}), 3) / numel(zf);
    
    temp= real(fftshift(ifft2(model_alphaf{ii} .* kzf)));  %equation for fast detection
    res_layer(:,:,ii)=temp/max(temp(:));
end


if frame>1
for x=1:size(res_layer,3)
 resp{x} = res_layer(:,:,x);
end

for x=1:size(res_layer,3)
  maxres(x)   = max(resp{x}(:));
 [row,col] = find(resp{x}==maxres(x),1);
  experts{x}.row = row;
  experts{x}.col = col;
end

        ip1=[];
        ip2=[];
        ip3=[];
        ip4=[];
        ip5=[];
        ip6=[];
        
        if frame > 1
            if length(nweights)==6
[input1,input2,input3,input4,input5,input6]=past7(experts,zf,pos,target_sz_t,cell_size,im,frame,image_fl,rects);
            
            elseif length(nweights)==3
           
    %%=======if using matlab
%%if using past 7 frames
     [input1,input2,input3,l1,l2,l3]=past3_hog(experts,zf,pos,target_sz_t,cell_size,im,frame,image_fl,rects);
          
ip1(1,:,:)=input1(:,:);
ip2(1,:,:)=input2(:,:);
ip3(1,:,:)=input3(:,:);
 data=cell(3,1);
 data{1,1}= reshape(ip1,[1764,8]);
data{2,1}= reshape(ip2,[1764,8]);
data{3,1}= reshape(ip3,[1764,8]);
% wtt = predict(net1,data);
wtt=[1,1;1,0.5;1,0.25];
Wt=wtt(:,1);
% dc=floor(min(Wt));
% Wt=Wt-dc;
% Wt=Wt/(max(Wt));

W=reshape(Wt,[1,1,3]);
          if frame>7 && frame<13
              
              avg_wt(1)=avg_wt(1)+Wt(1);
              avg_wt(2)=avg_wt(2)+1;
          end
          if frame<13
              threshold=0;
          else
              threshold=avg_wt(1)/avg_wt(2);
          end
              
    
          if Wt(1)>=threshold
              
              box = [pos([2,1]) - target_sz_t([2,1])/2, target_sz_t([2,1])];
              img=rgb2gray(im_prev);
              img=double(img);
              f8=imcrop(img, box);
              if isempty(f8)==1
              f8=zeros([32,32]);
              end
              f8=imresize(f8,[32,32]);
              cou=size(appearance,2);
%              
                                      
              f8=reshape(f8,[1024,1]);
              appearance=[appearance f8];
              appearance_image=cat(3,appearance_image,im);
              appearance_box=cat(1,appearance_box,pos);
          end

           if size(appearance,2)>=8
               past=appearance(:,end-7);
               past_image=appearance_image(:,:,end-23:end-21);
               past_box=appearance_box(end-7,:);
               appearance=appearance(:,end-6:end);
               appearance_image=appearance_image(:,:,end-20:end);
               appearance_box=appearance_box(end-6:end,:);
              
           end
%           
            end      
 
        end
        
        % Combine responses from multiple layers 
response = sum(bsxfun(@times, res_layer, W), length(W));
[vert_delta, horiz_delta] = find(response == max(response(:)), 1);
vert_delta  = vert_delta  - floor(size(zf,1)/2);
horiz_delta = horiz_delta - floor(size(zf,2)/2);

% Map the position to the image space
pos = pos + cell_size * [vert_delta - 1, horiz_delta - 1];

else
%=======================

% Combine responses from multiple layers
response = sum(bsxfun(@times, res_layer, nweights), length(nweights));
[vert_delta, horiz_delta] = find(response == max(response(:)), 1);
vert_delta  = vert_delta  - floor(size(zf,1)/2);
horiz_delta = horiz_delta - floor(size(zf,2)/2);

% Map the position to the image space
pos = pos + cell_size * [vert_delta - 1, horiz_delta - 1];
end
% ================================================================================
% Find target location
% ================================================================================
% Target location is at the maximum response. we must take into
% account the fact that, if the target doesn't move, the peak
% will appear at the top-left corner, not at the center (this is
% discussed in the KCF paper). The responses wrap around cyclically.



end

