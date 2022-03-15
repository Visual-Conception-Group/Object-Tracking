clc
clear all

images_folder='./sequences/bag/color/';
images = dir(fullfile(images_folder,'*.jpg'));
len = size(images,1);
names = cell(len,1);
for i = 1:len
    names{i} = [images_folder images(i).name];
end

Gt=dlmread('./sequences/bag/groundtruth.txt');

region=Gt(1,:);
warning off
params = set_parameters();
load net.mat
params.net=net;
disp('=========model loaded===================')


[state, ~, params] = tracker_Proposed_initialize(imread(names{1}), region, params);
addpath ./external/matconvnet/matlab
% vl_compilenn('enableGpu',true,'cudaRoot', '/usr/local/cuda-8.0')
vl_setupnn
state.rects = zeros(10, 4);
for i=1:80%len
    i
    state.image_fl{state.frame}=names{i};
    im= imread(names{i});
    [state, region] = tracker_Proposed_run(state,im, params);
   state.frame = state.frame + 1; 

    
end

results=state.rects;
