function [state, location, params] = tracker_Proposed_initialize(im, region, params)

    gray = double(rgb2gray(im));
    [height, width] = size(gray);

    % If the provided region is a polygon ...
    if numel(region) > 4
        x1 = round(min(region(1:2:end)));
        x2 = round(max(region(1:2:end)));
        y1 = round(min(region(2:2:end)));
        y2 = round(max(region(2:2:end)));
        region = round([x1, y1, x2 - x1, y2 - y1]);
    else
        region = round([round(region(1)), round(region(2)), ... 
        round(region(1) + region(3)) - round(region(1)), ...
        round(region(2) + region(4)) - round(region(2))]);
    end;
       params.rect_anno(1)=region(1,1);
   params.rect_anno(2)=region(1,2);
     params.rect_anno(3)=region(1,3);
     params.rect_anno(4)=region(1,4);
    
    x1 = max(0, region(1));
    y1 = max(0, region(2));
    x2 = min(width-1, region(1) + region(3) - 1);
    y2 = min(height-1, region(2) + region(4) - 1);

    template = gray((y1:y2)+1, (x1:x2)+1);
%     state.size = [x2 - x1 + 1, y2 - y1 + 1];

    state = struct('template', template, 'size', [x2 - x1 + 1, y2 - y1 + 1]);
    
    
    state.im1=im;
     state.im_prev=im;
         state.Wt=[1,0.5,0.25];
    state.window = max(state.size) * 2;
    
    state.position = [x1 + x2 + 1, y1 + y2 + 1] / 2;

    location = [x1, y1, state.size];

    if state.size(1)<16, state.size(1)=16;end 
    if state.size(2)<16, state.size(2)=16;end 
    
    target_sz = state.size([2,1]); 
    pos = state.position([2,1]); 
    
    state.pos1=pos;
    %===============================
    params.padding = struct('generic', 1.8, 'large', 1, 'height', 0.4);
    %disp('43')
    params.lambda = 1e-4;              % Regularization parameter (see Eqn 3 in our paper)
    params.output_sigma_factor = 0.1;  % Spatial bandwidth (proportional to the target size)
    params.interp_factor = 0.01;%0.01;       % Model learning rate (see Eqn 6a, 6b)
    params.cell_size = 4;              % Spatial cell size
    
    params.enableGPU = true ; 
%     params = initial_net(params);
    params.angl=[-8,-6,-4,-2,0,2,4,6,8];
    
    state.appearance=[];
    state.appearance_image=[];
    state.appearance_box=[];
    
    load M_xqda1.mat
    params.M_xqda=M_xqda;
    load W_xqda1.mat
    
    params.W_xqda=W_xqda;

    load LSTM8.mat % for 7 past frame
    params.net1=LSTM8;
 
    state.avg_wt=zeros(2,1);
    
    %===============================
    
    params.init_pos = pos; 
    params.wsize = target_sz; 

    randn('seed',0);rand('seed',0);

%initialize parts
state.frame = 1; %avot2017
        
    state.pos = floor(params.init_pos);
    state.target_sz = floor(params.wsize);


end
