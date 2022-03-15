function [seq, ground_truth,video_path] = load_video_info_vot2017(base_path, video)
%LOAD_VIDEO_INFO
%   Loads all the relevant information for the video in the given path:
%   the list of image files (cell array of strings), initial position
%   (1x2), target size (1x2), the ground truth information for precision
%   calculations (Nx2, for N frames), and the path where the images are
%   located. The ordering of coordinates and sizes is always [y, x].
%
%   Joao F. Henriques, 2014
%   http://www.isr.uc.pt/~henriques/


	%see if there's a suffix, specifying one of multiple targets, for
	%example the dot and number in 'Jogging.1' or 'Jogging.2'.
	if numel(video) >= 2 && video(end-1) == '.' && ~isnan(str2double(video(end))),
		suffix = video(end-1:end);  %remember the suffix
		video = video(1:end-2);  %remove it from the video name
	else
		suffix = '';
	end

	%full path to the video's files
	if base_path(end) ~= '/' && base_path(end) ~= '\',
		base_path(end+1) = '/';
	end
	video_path = [base_path];% '/'];

	%try to load ground truth from text file (Benchmark's format)
	filename = [video_path 'groundtruth' suffix '.txt'];
		gnd=importdata(filename);
    if size(gnd,2)==8
            for c=1:size(gnd,1)
        gn=[];
        g=gnd(c,:);
        if g(1)<g(7)
            gn(1)=g(1);
        else
            gn(1)=g(7);
        end
        if g(2)<g(4)
            gn(2)=g(2);
        else
            gn(2)=g(4);
        end
        if g(3)>g(5)
            gn(3)=g(3)-gn(1);
        else
            gn(3)=g(5)-gn(1);
        end
        if g(6)>g(8)
            gn(4)=g(6)-gn(2);
        else
            gn(4)=g(6)-gn(2);
        end
        ground_truth(c,:)=gn;
          if strcmp(video, 'nature')==1
         ground_truth(1,:)=[738.5100  225.5100  179.9800  119.9800];
        end
%          ground_truth(1,:)=[738.5100  225.5100  179.9800  119.9800];
            end
    gth=ground_truth;
    else 
        gth=gnd;
        f = fopen(filename);
	assert(f ~= -1, ['No initial position or ground truth to load ("' filename '").'])
        	try
		ground_truth = textscan(f, '%f,%f,%f,%f', 'ReturnOnError',false);  
	catch  %#ok, try different format (no commas)
		frewind(f);
		ground_truth = textscan(f, '%f %f %f %f');  
    end
	ground_truth = cat(2, ground_truth{:});
	fclose(f);

    end
	%the format is [x, y, width, height]

 
  
           
  	rect_anno(1)=ground_truth(1,1);
    rect_anno(2)=ground_truth(1,2);
    rect_anno(3)=ground_truth(1,3);
    rect_anno(4)=ground_truth(1,4);
    rect_anno=round(rect_anno);
	%set initial position and size
	target_sz = [ground_truth(1,4), ground_truth(1,3)];
	pos = [ground_truth(1,2), ground_truth(1,1)] + floor(target_sz/2);
	
	if size(ground_truth,1) == 1,
		%we have ground truth for the first frame only (initial position)
		ground_truth = [];
	else
		%store positions instead of boxes
		ground_truth = ground_truth(:,[2,1]) + ground_truth(:,[4,3]) / 2;
	end
	
	
	%from now on, work in the subfolder where all the images are
	video_path = [video_path 'img/'];
	
	%for these sequences, we must limit ourselves to a range of frames.
	%for all others, we just load all png/jpg files in the folder.
% 	frames = {'David', 300, 770;
% 			  'Football1', 1, 74;
% 			  'Freeman3', 1, 460;
% 			  'Freeman4', 1, 283;
%               'Diving', 1, 215};
	
	idx = [];%find(strcmpi(video, frames(:,1)));
	
	if isempty(idx),
		%general case, just list all images
		img_files = dir([video_path '*.png']);
		if isempty(img_files),
			img_files = dir([video_path '*.jpg']);
			assert(~isempty(img_files), 'No image files to load.')
		end
		img_files = sort({img_files.name});
	else
		%list specified frames. try png first, then jpg.
		if exist(sprintf('%s%04i.png', video_path, frames{idx,2}), 'file'),
			img_files = num2str((frames{idx,2} : frames{idx,3})', '%04i.png');
			
		elseif exist(sprintf('%s%04i.jpg', video_path, frames{idx,2}), 'file'),
			img_files = num2str((frames{idx,2} : frames{idx,3})', '%04i.jpg');
			
		else
			error('No image files to load.')
		end
		
		img_files = cellstr(img_files);
    end
        ground_truth=round(gth);
	  seq.len = size(gth, 1);
seq.init_rect = gth(1,:);
seq.s_frames = cellstr(img_files);
	
end

