
function [input1,input2,input3]=model_pool(experts,zf,pos,target_sz,cell_size,im,frame,image_fl,rects,appearance)

gt=rects;

im = imread(image_fl{frame});

if size(im,3)>1
    img=rgb2gray(im);
else 
    img=im;
end

for i=1:length(experts) 
vert_delta = experts{i}.row; horiz_delta = experts{i}.col;
        vert_delta = vert_delta - floor(size(zf,1)/2);
        horiz_delta = horiz_delta - floor(size(zf,2)/2);
        
        pos = pos + cell_size * [vert_delta - 1, horiz_delta - 1];
        
        box(i,:) = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])];
end

f8=imcrop(img, box(1,:));
if isempty(f8)==1
    f8=zeros([32,32]);
end
f8=imresize(f8,[32,32]);
f8=reshape(f8,[1024,1]);
input1(:,1:7)=appearance;
input1(:,8)=f8;


f8=imcrop(img, box(2,:));
if isempty(f8)==1
    f8=zeros([32,32]);
end
f8=imresize(f8,[32,32]);
f8=reshape(f8,[1024,1]);
input2(:,1:7)=appearance;
input2(:,8)=f8;


f8=imcrop(img, box(3,:));
if isempty(f8)==1
    f8=zeros([32,32]);
end
f8=imresize(f8,[32,32]);
f8=reshape(f8,[1024,1]);
input3(:,1:7)=appearance;
input3(:,8)=f8;


end
