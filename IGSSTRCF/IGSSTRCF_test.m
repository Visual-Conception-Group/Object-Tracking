
clc
clear all
close all

setup_path();
base_path   = '/home/arjun18023/Thesis/Datasets/LASOT/LaSOTTesting/';% add the path of your data here
%Load video information
  dirs = dir(base_path);
        videos = {dirs.name};
        videos(strcmp('.', videos) | strcmp('..', videos) | ...
            strcmp('anno', videos) | ~[dirs.isdir]) = [];
% Initialize the tracker
params = set_parameters();
disp('============loading net===================')
load vggmnet.mat
load vgg16net.mat
params.vggmnet=vggmnet;
params.vgg16net=vgg16net;
disp('=========model loaded===================')

for vid =1:numel(videos)
    videos{vid}
    close all;
    video_path = [base_path videos{vid} '/' ];
    [seq, ground_truth,video_path] = load_video_info_lasot(video_path,videos{vid});
    region=seq.init_rect;
    names=seq.s_frames;
    [state, ~, params] = tracker_IGSSTRCF_initialize(imread(names{1}), region, params);
    addpath /home/arjun18023/Monika/vot-toolkit/workspace/external/matconvnet/matlab
    % vl_compilenn('enableGpu',true,'cudaRoot', '/usr/local/cuda-8.0')
    vl_setupnn
    warning
    state.rect_position = zeros(10, 4);
    state.rects = zeros(10, 4);
    time=0;
    fps=0;
    for i=1:seq.len
        i
        state.vid=videos{vid};
        im= imread(names{i});
        [state, region,times] = IGSSTRCF_optimized(state,im, params,time);
        if i>1
            fps=fps+times;
        end
        state.frame = state.frame + 1; 
    end
    results.res = state.rect_position;
    speed=(seq.len-1)/fps
    result=round(results.res);
    fname1=['./Results/',videos{vid},'.txt'];
    dlmwrite(fname1,result)
end

