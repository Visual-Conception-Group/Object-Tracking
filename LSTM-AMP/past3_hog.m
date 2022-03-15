
function [input1,input2,input3,l1,l2,l3]=past3_hog(experts,zf,pos,target_sz,cell_size,im,frame,image_fl,rects)

gt=rects;

if frame>7
im = imread(image_fl{frame});
im1 = imread(image_fl{frame-1});
im2 = imread(image_fl{frame-2});
im3 = imread(image_fl{frame-3});
im4 = imread(image_fl{frame-4});
im5 = imread(image_fl{frame-5});
im6 = imread(image_fl{frame-6});
im7 = imread(image_fl{frame-7});
elseif frame==7
    im = imread(image_fl{frame});
im1 = imread(image_fl{frame-1});
im2 = imread(image_fl{frame-2});
im3 = imread(image_fl{frame-3});
im4 = imread(image_fl{frame-4});
im5 = imread(image_fl{frame-5});
im6 = imread(image_fl{frame-6});
im7 = zeros([size(im)]);
elseif frame==6
    im = imread(image_fl{frame});
im1 = imread(image_fl{frame-1});
im2 = imread(image_fl{frame-2});
im3 = imread(image_fl{frame-3});
im4 = imread(image_fl{frame-4});
im5 = imread(image_fl{frame-5});
im6 = zeros([size(im)]);
im7 = zeros([size(im)]);
elseif frame==5
    im = imread(image_fl{frame});
im1 = imread(image_fl{frame-1});
im2 = imread(image_fl{frame-2});
im3 = imread(image_fl{frame-3});
im4 = imread(image_fl{frame-4});
im5 = zeros([size(im)]);
im6 = zeros([size(im)]);
im7 = zeros([size(im)]);
elseif frame==4
    im = imread(image_fl{frame});
im1 = imread(image_fl{frame-1});
im2 = imread(image_fl{frame-2});
im3 = imread(image_fl{frame-3});
im4 = zeros([size(im)]);
im5 = zeros([size(im)]);
im6 = zeros([size(im)]);
im7 = zeros([size(im)]);
elseif frame==3
    im = imread(image_fl{frame});
im1 = imread(image_fl{frame-1});
im2 = imread(image_fl{frame-2});
im3 = zeros([size(im)]);
im4 = zeros([size(im)]);
im5 = zeros([size(im)]);
im6 = zeros([size(im)]);
im7 = zeros([size(im)]);

elseif frame==2
    im = imread(image_fl{frame});
im1 = imread(image_fl{frame-1});
im2 = zeros([size(im)]);
im3 = zeros([size(im)]);
im4 = zeros([size(im)]);
im5 = zeros([size(im)]);
im6 = zeros([size(im)]);
im7 = zeros([size(im)]);

end


for i=1:length(experts) 
vert_delta = experts{i}.row; horiz_delta = experts{i}.col;
        vert_delta = vert_delta - floor(size(zf,1)/2);
        horiz_delta = horiz_delta - floor(size(zf,2)/2);
        
        pos = pos + cell_size * [vert_delta - 1, horiz_delta - 1];
        
        box(i,:) = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])];
end
if frame>1
if size(im,3)>1
    img=rgb2gray(im);
    img1=rgb2gray(im1);
    img2=rgb2gray(im2);
    img3=rgb2gray(im3);
    img4=rgb2gray(im4);
    img5=rgb2gray(im5);
    img6=rgb2gray(im6);
    img7=rgb2gray(im7);
else
    img=im;
    img1=im1;
    img2=im2;
    img3=im3;
    img4=im4;
    img5=im5;
    img6=im6;
    img7=im7;
   
end
end

if frame>7
f1=imcrop(img7, gt(frame-7,:));
f2=imcrop(img6, gt(frame-6,:));
f3=imcrop(img5, gt(frame-5,:));
f4=imcrop(img4, gt(frame-4,:));
f5=imcrop(img3, gt(frame-3,:));
f6=imcrop(img2, gt(frame-2,:));
f7=imcrop(img1, gt(frame-1,:));
elseif frame==7
    f1=zeros([32,32]);
f2=imcrop(img6, gt(frame-6,:));
f3=imcrop(img5, gt(frame-5,:));
f4=imcrop(img4, gt(frame-4,:));
f5=imcrop(img3, gt(frame-3,:));
f6=imcrop(img2, gt(frame-2,:));
f7=imcrop(img1, gt(frame-1,:));
elseif frame==6
    f1=zeros([32,32]);
f2=zeros([32,32]);
f3=imcrop(img5, gt(frame-5,:));
f4=imcrop(img4, gt(frame-4,:));
f5=imcrop(img3, gt(frame-3,:));
f6=imcrop(img2, gt(frame-2,:));
f7=imcrop(img1, gt(frame-1,:));
elseif frame==5
    f1=zeros([32,32]);
f2=zeros([32,32]);
f3=zeros([32,32]);
f4=imcrop(img4, gt(frame-4,:));
f5=imcrop(img3, gt(frame-3,:));
f6=imcrop(img2, gt(frame-2,:));
f7=imcrop(img1, gt(frame-1,:));
elseif frame==4
    f1=zeros([32,32]);
f2=zeros([32,32]);
f3=zeros([32,32]);
f4=zeros([32,32]);
f5=imcrop(img3, gt(frame-3,:));
f6=imcrop(img2, gt(frame-2,:));
f7=imcrop(img1, gt(frame-1,:));
elseif frame==3
    f1=zeros([32,32]);
f2=zeros([32,32]);
f3=zeros([32,32]);
f4=zeros([32,32]);
f5=zeros([32,32]);
f6=imcrop(img2, gt(frame-2,:));
f7=imcrop(img1, gt(frame-1,:));
elseif frame==2
    f1=zeros([32,32]);
f2=zeros([32,32]);
f3=zeros([32,32]);
f4=zeros([32,32]);
f5=zeros([32,32]);
f6=zeros([32,32]);
f7=imcrop(img1, gt(frame-1,:));
end
% 
if isempty(f1)==1
    f1=zeros([32,32]);
end
if isempty(f2)==1
    f2=zeros([32,32]);
end
if isempty(f3)==1
    f3=zeros([32,32]);
end
if isempty(f4)==1
    f4=zeros([32,32]);
end
if isempty(f5)==1
    f5=zeros([32,32]);
end
if isempty(f6)==1
    f6=zeros([32,32]);
end
if isempty(f7)==1
    f7=zeros([32,32]);
end

f1=imresize(f1,[32,32]);
f2=imresize(f2,[32,32]);
f3=imresize(f3,[32,32]);
f4=imresize(f4,[32,32]);
f5=imresize(f5,[32,32]);
f6=imresize(f6,[32,32]);
f7=imresize(f7,[32,32]);

f1 = extractHOGFeatures(f1,'CellSize',[4 4]);
f2 = extractHOGFeatures(f2,'CellSize',[4 4]);
f3 = extractHOGFeatures(f3,'CellSize',[4 4]);
f4 = extractHOGFeatures(f4,'CellSize',[4 4]);
f5 = extractHOGFeatures(f5,'CellSize',[4 4]);
f6 = extractHOGFeatures(f6,'CellSize',[4 4]);
f7 = extractHOGFeatures(f7,'CellSize',[4 4]);


f1=reshape(f1,[1764,1]);
f2=reshape(f2,[1764,1]);
f3=reshape(f3,[1764,1]);
f4=reshape(f4,[1764,1]);
f5=reshape(f5,[1764,1]);
f6=reshape(f6,[1764,1]);
f7=reshape(f7,[1764,1]);

input(:,1)=f1;
input(:,2)=f2;
input(:,3)=f3;
input(:,4)=f4;
input(:,5)=f5;
input(:,6)=f6;
input(:,7)=f7;


f8=imcrop(img, box(1,:));
l1=imcrop(im, box(1,:));
if isempty(f8)==1
    f8=zeros([32,32]);
end
f8=imresize(f8,[32,32]);
f8 = extractHOGFeatures(f8,'CellSize',[4 4]);
f8=reshape(f8,[1764,1]);
input1(:,1:7)=input(:,1:7);
input1(:,8)=f8;

f8=imcrop(img, box(2,:));
l2=imcrop(im, box(2,:));
if isempty(f8)==1
    f8=zeros([32,32]);
end
f8=imresize(f8,[32,32]);
f8 = extractHOGFeatures(f8,'CellSize',[4 4]);
f8=reshape(f8,[1764,1]);
input2(:,1:7)=input(:,1:7);
input2(:,8)=f8;

f8=imcrop(img, box(3,:));
l3=imcrop(im, box(3,:));
if isempty(f8)==1
    f8=zeros([32,32]);
end
f8=imresize(f8,[32,32]);
f8 = extractHOGFeatures(f8,'CellSize',[4 4]);
f8=reshape(f8,[1764,1]);
input3(:,1:7)=input(:,1:7);
input3(:,8)=f8;


end
