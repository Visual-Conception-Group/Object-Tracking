function IGSSTRCF()
 
% *************************************************************
% VOT: Always call exit command at the end to terminate Matlab!
% *************************************************************
% cleanup = onCleanup(@() exit() );
disp('23')
% *************************************************************
% VOT: Set random seed to a different value every time.
% *************************************************************
RandStream.setGlobalStream(RandStream('mt19937ar', 'Seed', sum(clock)));

% **********************************
% VOT: Get initialization data
% **********************************
[handle, image, region] = vot('polygon');

% Initialize the tracker
params = set_parameters();
% disp(handle)
% disp(image)
% disp(params)

disp('============loading net===================')
load vggmnet.mat
load vgg16net.mat

disp('============loading net===================')
params.vggmnet=vggmnet;
params.vgg16net=vgg16net;
disp('=========model loaded===================')

disp('36')
disp(image)
disp(region)


[state, ~, params] = tracker_QSTRCF_initialize(imread(image{1}), region, params);
state.rects = zeros(10, 4);
% addpath /data/home/monika/ALLTRACKERS/BACF_toUpload/
addpath /home/arjun18023/Monika/vot-toolkit/workspace/external/matconvnet/
addpath /home/arjun18023/Monika/vot-toolkit/workspace/external/matconvnet/matlab/
% addpath /data/home/monika/DPRF_Arjun/vot-toolkit-master_ver5.0.1/workspace/QBACF_tracker/matlab
% addpath /data/home/monika/DPRF_Arjun/vot-toolkit-master_ver5.0.1/workspace/QBACF_tracker/
% % vl_compilenn('enableGpu',true,'cudaRoot', '/usr/local/cuda-8.0')
vl_setupnn
while true
   
    % **********************************
    % VOT: Get next frame
    % **********************************
    [handle, image] = handle.frame(handle);

    if isempty(image)
        break;
    end;
    disp('48')
%     state.image_fl{state.frame}=image;
	% Perform a tracking step, obtain new region
    disp(image)
    [state, region] = QSTRCF_optimized(state, imread(image{1}), params);
      state.frame = state.frame + 1; %avot2017
    % **********************************
    % VOT: Report position for frame
    % **********************************
    handle = handle.report(handle, region);
    
end;

% **********************************
% VOT: Output the results
% **********************************
% handle.quit(handle);

end

