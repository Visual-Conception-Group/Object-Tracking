function APP_LSTM()
%%DPRF_TRACKER VOT INTEGRATION
% This function is used to initialize communication with the VOT toolkit for DPRF_Tracker.
%
% The resulting handle is a structure provides several functions for
% further interaction:
% - frame(handle): Get new frame from the sequence.
% - report(handle, region): Report region for current frame and advance.
% - quit(handle): Closes the communication and saves the data.
%
% Input:
% - format (string): Desired region input format.
%
% Output:
% - handle (structure): Updated communication handle structure.
% - image (string): Path to the first image file.
% - region (vector): Initial region encoded as a rectangle or as a polygon.

% *************************************************************
% VOT: Always call exit command at the end to terminate Matlab!
% *************************************************************
% cleanup = onCleanup(@() exit() );

% *************************************************************
% VOT: Set random seed to a different value every time.
% *************************************************************
RandStream.setGlobalStream(RandStream('mt19937ar', 'Seed', sum(clock)));

% **********************************
% VOT: Get initialization data
% **********************************
[handle, image, region] = vot1('polygon');

% Initialize the tracker
params = set_parameters();
% disp(handle)
% disp(image)
% disp(params)

load net.mat
params.net=net;
[state, ~, params] = tracker_Proposed_initialize(imread(image{1}), region, params);
state.rects = zeros(10, 4);
addpath ./external/matconvnet/matlab
% vl_compilenn('enableGpu',true,'cudaRoot', '/usr/local/cuda-8.0')
vl_setupnn
while true
   
    % **********************************
    % VOT: Get next frame
    % **********************************
    [handle, image] = handle.frame(handle);

    if isempty(image)
        break;
    end;
    state.image_fl{state.frame}=image;
	% Perform a tracking step, obtain new region
    [state, region] = tracker_Proposed_run(state, imread(image), params);
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



