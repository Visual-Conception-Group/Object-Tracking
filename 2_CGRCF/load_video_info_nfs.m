function [seq, ground_truth,video_path] = load_video_info_nfs(base_path, video)
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
	video_path = [base_path video '/' video '/240/' ];
    
    if exist(video_path)==0
        video_path = [base_path video '/240/' ];
    end
 	%try to load ground truth from text file (Benchmark's format)
    gt_pth=['/data/home/monika/CF2/nfs_gt/'];
	filename = [gt_pth video suffix '.txt'];
	f = fopen(filename);
	assert(f ~= -1, ['No initial position or ground truth to load ("' filename '").'])
 	grnd=importdata(filename);
    gd=[grnd(:,2),grnd(:,3), grnd(:,4)-grnd(:,2),grnd(:,5)-grnd(:,3)];
%     gnd=gnd{1:end};
    switch video
        case 'airboard_1'
    gnd=[285 433 42 22];
        case 'bird_2'
        gnd=[514 199 48 29]; 
        case 'bowling_ball'
        gnd=[368 428 18 18];   
        case 'bunny'
        gnd=[570 410 745-570 614-410];
        case 'car'
        gnd=[687 528 754-687 570-528];
        case 'car_camaro'
        gnd=[687 325 753-687 348-325];
        case 'car_drifting'
        gnd=[327 219 564-327 339-219];
        case 'car_jumping'
        gnd=[872 436 1224-872 704-436];     
        case 'car_rc_rolling'
        gnd=[1169 368 1278-1169 429-368];
        case 'car_rc_rotating'
        gnd=[646 473 892-646 712-473];
        case 'car_side'
        gnd=[689 446 842-689 519-446]; 
        case 'car_white'
        gnd=[664 499 786-664 607-499];
        case 'cheetah'
        gnd=[525 286 945-525 516-286];
        case 'cup'
        gnd=[500 178 586-500 309-178];
        case 'cup_2'
        gnd=[150 404 419-150 681-404];
        case 'dog'
        gnd=[558 253 603-558 340-253];
        case 'dog_1'
        gnd=[382 335 519-382 449-335];
        case 'airplane_landing'
            gnd=[215 362 456-215 439-362];
        case 'airtable_3'
            gnd=[291 496 344-291 526-496];
        case 'basketball_1'
            gnd=[330 434 364-330 465-434];
        case 'basketball_2'
            gnd=[342 206 380-342 245-206];
        case 'Gymnastics'
            gnd=[520 260 564-520 369-260];
        case 'MachLoop_jet'
            gnd=[478 443 506-478 467-443 ];
        case 'basketball_3'
            gnd = [611 328 638-611 355-328]
        case 'basketball_6'
            gnd=[471 339 493-471 359-339];
        case 'basketball_7'
            gnd=[575 365 622-575 510-365];
        case 'basketball_player'
            gnd=[697 256 783-697 472-256];
        case 'basketball_player_2'
            gnd=[704 368 750-704 503-368];
        case 'beach_flipback_person'
            gnd=[351 6 411-351 65-6];
        case 'bee'
            gnd=[22 319 141-22 392-319];
        case 'biker_acrobat'
            gnd=[699 346 833-699 443-346];
        case 'biker_all_1'
            gnd=[332 304 430-332 501-304];
        case 'biker_head_3'
            gnd=[346 352 402-346 414-352];
        case 'biker_head_2'
            gnd=[33 480 71-33 517-480];
        case 'water_ski_2'
            gnd=[111 444 200-111 579-444];
        case 'biker_upper_body'
            gnd=[300 469 364-300 554-469];
        case 'biker_whole_body'
            gnd=[349 229 462-349 411-229];
        case 'billiard_2'
            gnd=[447 153 485-447 188-153];
        case 'billiard_3'
            gnd=[195 317 237-195 359-317];
        case 'billiard_6'
            gnd=[1096 364 1131-1096 397-364];
        case 'billiard_7'
            gnd=[484 470 546-484 529-470];
        case 'billiard_8'
            gnd=[629 262 667-629 302-262];
        case 'book'
            gnd=[492 207 771-492 322-207];
        case 'bottle'
            gnd=[178 340 375-178 943-340];
        case 'bowling_1'
            gnd=[443 284 467-443 305-284];
        case 'bowling_2'
            gnd=[479 402 501-479 423-402];
        case 'bowling_3'
            gnd=[452 63 557-452 168-63];
        case 'bowling_6'
            gnd=[216 302 265-216 351-302];
        case 'dog'
                gnd=[558 253 603-558 340-253];
        case 'dog_1'
            gnd=[382 335 519-382 449-335 ];
        case 'dog_2'
            gnd=[579 315 646-579 367-315];
        case 'dog_3'
            gnd=[248 301 291-248 366-301];
        case 'dogs'
                gnd=[702 240 762-702 300-240];
        case 'dollar'
            gnd=[536 329 717-536 407-329];
        case 'drone'
            gnd=[472 519 593-472 575-519];
        case 'ducks_lake'
                gnd=[1171 224 1228-1171 262-224];
        case 'exit'
            gnd=[644 317 706-644 366-317];
        case 'first'
            gnd=[467 280 679-467 370-280];
        case 'flower'
            gnd=[686 107 886-686 267-107];
        case 'footbal_skill'
                gnd=[904 85 1005-904 182-85];
        case 'helicopter'
                gnd=[952 336 1002-952 365-336];
        case 'horse_jumping'
            gnd=[159 227 214-159 324-227];
        case 'horse_running'
            gnd=[874 235 960-874 377-235];
        case 'iceskating_6'
                gnd=[779 339 812-779 395-339];
        case 'jellyfish_5'
                gnd=[697 280 781-697 355-280];
        case 'kid_swing'
            gnd=[511 223 603-511 311-223];
        case 'motorcross'
            gnd=[444 171 512-444 275-171];
        case 'motorcross_kawasaki'
                gnd=[609 321 670-609 372-321];
        case 'parkour'
            gnd=[1025 277 1073-1025 330-277];
        case 'person_scooter'
            gnd=[443 205 633-443 644-205];
        case 'pingpong_2'
                gnd=[374 351 401-374 378-351];
        case 'pingpong_7'
                gnd=[582 400 614-582 431-400];
        case 'pingpong_8'
                gnd=[401 355 421-401 375-355];
        case 'purse'
            gnd=[293 541 336-293 616-541];
        case 'rubber'
            gnd=[186 273 292-186 376-273];
        case 'running'
                gnd=[647 366 701-647 492-366];
        case 'running_2'
            gnd=[477 339 518-477 411-339];
        case 'running_100_m'
            gnd=[689 302 793-689 533-302];
        case 'running_100_m_2'
                gnd=[381 337 480-381 580-337];
        case 'shuffleboard_1'
            gnd=[908 382 949-908 424-382];
        case 'shuffleboard_2'
                gnd=[923 285 971-923 327-285];
        case 'shuffleboard_4'
            gnd=[436 451 499-436 514-451];
        case 'shuffleboard_5'
            gnd=[506 384 565-506 440-384];
        case 'shuffleboard_6'
            gnd=[327 527 352-327 549-527];
        case 'shuffletable_2'
            gnd=[332 233 356-332 259-233];
        case 'shuffletable_3'
            gnd=[313 148 337-313 175-148];
        case 'shuffletable_4'
            gnd=[254 317 303-254 364-317];
        case 'Skiing_red'
            gnd=[441 190 479-441 232-190];
        case 'ski_long'
            gnd=[624 298 647-624 334-298];
        case 'Skydiving'
            gnd=[1005 618 1126-1005 856-618];
        case 'soccer_ball'
        gnd=[ 484 603 581-484 697-603];
        case 'soccer_ball_2'
            gnd=[217 569 236-217 590-569];
        case 'soccer_ball_3'
            gnd=[329 599 361-329 627-599];
        case 'soccer_player_2'
            gnd=[508 260 557-508 328-260];
        case 'soccer_player_3'
                gnd=[205 273 237-205 327-273];
        case 'stop_sign'
            gnd=[307 457 374-307 539-457];
        case 'walking'
                gnd=[270 457 362-207 735-457];
        case 'yoyo'
            gnd=[105 778 153-105 824-778];
        case 'suv'
            gnd=[427 155 822-427 498-155];
        case 'tiger'
            gnd=[542 347 606-542 394-347];
        case 'walking_3'
            gnd=[307 403 472-307 943-403];
        case 'zebra_fish'
            gnd=[649 139 919-649 402-139];
            
 end
	%the format is [x, y, width, height]
% matlab
% ground_truth = textscan(f, '%f,%f,%f,%f', 'ReturnOnError',false);  
% 	catch  %#ok, try different format (no commas)
% 		frewind(f);
% 		ground_truth = textscan(f, '%f %f %f %f');  
%     end
    ground_truth=gnd;
% 	ground_truth = cat(2, ground_truth{:});	fclose(f);
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
	video_path = [video_path video '/'];
	
	%for these sequences, we must limit ourselves to a range of frames.
	%for all others, we just load all png/jpg files in the folder.
	frames = {'David', 300, 770;
			  'Football1', 1, 74;
			  'Freeman3', 1, 460;
			  'Freeman4', 1, 283;
              'Diving', 1, 215};
	
	idx = find(strcmpi(video, frames(:,1)));
	
	if isempty(idx),
		%general case, just list all images
		img_files = dir([video_path '*.png']);
		if isempty(img_files),
			img_files = dir([video_path '*.jpg']);
			assert(~isempty(img_files), 'No image files to load.')
        end
%         img_f=img_files.name;
%         img_fi=strcat([video_path {img_f}]);
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
    ground_truth=round(gd);
	  seq.len = size(gd, 1);
seq.init_rect = gd(1,:);
seq.s_frames = cellstr(img_files);
	
end

