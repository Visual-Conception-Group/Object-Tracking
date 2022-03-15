
function [input1,input2,input3,l1,l2,l3]=monika1_hog(experts,zf,pos,target_sz,cell_size,im,frame,image_fl,rects)

gt=rects;

if frame>2
im = imread(image_fl{frame});
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

else
    img=im;
   
end
end




f8=imcrop(img, box(1,:));
l1=imcrop(im, box(1,:));
if isempty(f8)==1
    f8=zeros([32,32]);
end
f8=imresize(f8,[32,32]);
f8 = extractHOGFeatures(f8,'CellSize',[4 4]);
f8=reshape(f8,[1764,1]);
input1=f8;


f8=imcrop(img, box(2,:));
l2=imcrop(im, box(2,:));
if isempty(f8)==1
    f8=zeros([32,32]);
end
f8=imresize(f8,[32,32]);
f8 = extractHOGFeatures(f8,'CellSize',[4 4]);
f8=reshape(f8,[1764,1]);

input2=f8;


f8=imcrop(img, box(3,:));
l3=imcrop(im, box(3,:));
if isempty(f8)==1
    f8=zeros([32,32]);
end
f8=imresize(f8,[32,32]);
f8 = extractHOGFeatures(f8,'CellSize',[4 4]);
f8=reshape(f8,[1764,1]);
input3=f8;

end
