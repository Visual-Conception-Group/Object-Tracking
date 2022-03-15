function [state, location] = tracker_Proposed_run(state, im, params)


target_sz = state.size([2,1]); 
pos = state.position([2,1]); 

%==================================
myangle=0; 
calc_angl=0;

indLayers = [37 28 19];
nweights  = [1 0.5 0.25 ];

past=0;

numLayers = length(indLayers);
im_sz     = size(im);

window_sz = get_search_window(target_sz, im_sz, params.padding);

% Compute the sigma for the Gaussian function label
output_sigma = sqrt(prod(target_sz)) * params.output_sigma_factor / params.cell_size;

%create regression labels, gaussian shaped, with a bandwidth
%proportional to target size    d=bsxfun(@times,c,[1 2]);
l1_patch_num = floor(window_sz/ params.cell_size);

% Pre-compute the Fourier Transform of the Gaussian function label
yf = fft2(gaussian_shaped_labels(output_sigma, l1_patch_num));

% Pre-compute and cache the cosine window (for avoiding boundary discontinuity)
cos_window = hann(size(yf,1)) * hann(size(yf,2))';

% Initialize variables for calculating FPS and distance precision

% rects(1,:)=rect_anno(1,:);
nweights  = reshape(nweights,1,1,[]);

% Note: variables ending with 'f' are in the Fourier domain.
model_xf     = cell(1, numLayers);
model_alphaf = cell(1, numLayers);

current_scale_factor=1;


    if ismatrix(im)
        im = cat(3, im, im, im);
        state.im_prev = cat(3, state.im_prev, state.im_prev, state.im_prev);
    end
    % ================================================================================
    % Predicting the object position from the learned object model
    % ================================================================================
    if state.frame > 1

        target_sz_t=target_sz*current_scale_factor;
        feat  = extractFeature(state.im1, state.pos1, window_sz, cos_window, indLayers,params);
   
    
    % Model update
    [state.model_xf, state.model_alphaf] = updateModel(feat, yf, params.interp_factor, params.lambda, state.frame, ...
        state.model_xf, state.model_alphaf);
    
    % ================================================================================
    % Save predicted position and timing
    % ================================================================================
  
%   -------------------------------------------------------------------------        
       
        % Extracting hierarchical convolutional features
        feat = extractFeature(im, pos, window_sz, cos_window, indLayers,params);
        % Predict position
        [pos state.appearance,state.avg_wt,state.appearance_image,state.appearance_box,past,state.past_image,state.past_box,state.Wt] = predictPosition(feat, pos, indLayers, nweights, params.cell_size, l1_patch_num, ...
            state.model_xf, state.model_alphaf,state.frame,params.rect_anno,state.image_fl,im,state.rects,target_sz_t,state.appearance,state.avg_wt,state.appearance_image,state.appearance_box,state.im_prev,past,params.net1,state.Wt);
        
        % Scale estimation
        [current_scale_factor calc_angl] = estimate_scale( rgb2gray(im), pos, current_scale_factor,params.angl,params,state);   
        calc_angl=0-calc_angl;
        myangle=calc_angl+myangle;
    else
     
       state.model_xf=[];
       state.model_alphaf=[];
        [params, state] = init_scale_para(rgb2gray(im), target_sz, pos,params.angl,params,state);
     
    end
    
    % ================================================================================
    % Learning correlation filters over hierarchical convolutional features
    % ================================================================================
    % Extracting hierarchical convolutional features
positions(state.frame,:) = pos;

      state.im1=im;
      state.pos1=pos;

        state.target_sz_t=target_sz*current_scale_factor;
    box = [pos([2,1]) - state.target_sz_t([2,1])/2, state.target_sz_t([2,1])];
        currentimg=rgb2gray(im);
    currentimg=double(currentimg);
    query=imcrop(currentimg, box);
    if isempty(query)==1
   query=zeros([32,32]);
end
              query=imresize(query,[32,32]);
              query=reshape(query,[1024,1]);
     if (size(state.appearance,2)==7 && length(past) > 1 ) || state.frame==14 ||state.frame==15 || state.frame==16 || state.frame==17
         dist_xqdaa = MahDist(params.M_xqda, state.appearance' * params.W_xqda, past' * params.W_xqda); 
            [val posi]=min(dist_xqdaa);
            dist_xqda = MahDist(params.M_xqda, [past state.appearance(:,1:6)]' * params.W_xqda, state.appearance' * params.W_xqda); 
            dist_eucli=norm([past state.appearance(:,1:6)]-state.appearance);
            dist_query=norm([query,query,query,query,query,query,query]-state.appearance);
            avrg=sum(sum(dist_xqda))/43;
         dist_xqda1 = MahDist(params.M_xqda, state.appearance' * params.W_xqda, query' * params.W_xqda);   

           if dist_eucli < dist_query

               state.im1=state.appearance_image(:,:,((posi-1)*3)+1:((posi-1)*3)+3);
              state.pos1=state.appearance_box(posi,:);
            end
     end

    
    feat  = extractFeature(state.im1, state.pos1, window_sz, cos_window, indLayers,params);
    % Model update
    [state.model_xf, state.model_alphaf] = updateModel(feat, yf, params.interp_factor, params.lambda, state.frame, ...
        state.model_xf, state.model_alphaf);
    
    %==============================================================
    
    positions(state.frame,:) = pos;
    
    state.target_sz_t=target_sz*current_scale_factor;

    state.rects(state.frame,:)=box;

%     figure(1)
%     imshow(im,[])
%     hold on 
%     rectangle('Position',box)
%     pause(.5)

 x=box(1);
    y=box(2);
    w=box(3);
    h=box(4);
    
    A=[x y];
    B=[x+w,y];
    D=[x,y+h];
    C=[x+w,y+h];
    E=[x+(w/2),y+(h/2)];
    
    

     R1 = [cosd(myangle), -sind(myangle);sind(myangle), cosd(myangle)];  % CUMULATIVE
    R2 = [cosd(calc_angl), -sind(calc_angl);sind(calc_angl), cosd(calc_angl)];  % NOT CUMULTIVE
    
    A1=R1*A';
    B1=R1*B';
    C1=R1*C';
    D1=R1*D';
    E1=R1*E';
    
    displ=E'-E1;
    A1=A1+displ;
    B1=B1+displ;
    C1=C1+displ;
    D1=D1+displ;
    
    
    A2=R2*A';
    B2=R2*B';
    C2=R2*C';
    D2=R2*D';
    E2=R2*E';
    
    displ=E'-E2;
    A2=A2+displ;
    B2=B2+displ;
    C2=C2+displ;
    D2=D2+displ;
    
    res1(state.frame,:)=[A1' B1' C1' D1'];  %CUMULATIVE ROTATION
    res2(state.frame,:)=[A2' B2' C2' D2'];  % NOT CUMULATIVE ROTATION
  state.im_prev=im;  

% ================================================================================
        
    %save position and size
    state.position = pos([2,1]);
    state.size = target_sz([2,1]); %avot2017

    location = [state.position - state.size/2, state.size];

    location = str2num(num2str(location)); 
    

    end
