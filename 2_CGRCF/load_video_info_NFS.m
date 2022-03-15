function [seq, ground_truth,img_path] = load_video_info_NFS(video_path,videoname)

% ground_truth = dlmread([video_path 'groundtruth_rect.txt']);
fid = fopen([video_path  videoname '.txt'],'rt');
x = textscan(fid,'%f%f%f%f%f%f%f%f%f%s%*[^\n]','Delimiter',' ');

R = cell2mat(x(1:9));
ground_truth = [R(:,2),R(:,3),R(:,4)-R(:,2),R(:,5)-R(:,3)];
% label = cell2mat(x{10})

% ground_truth = dlmread([video_path  videoname '.txt']);
seq.format = 'otb';
seq.len = size(ground_truth, 1);
seq.init_rect = ground_truth(1,:);

img_path = [video_path videoname '/'];

% if exist([img_path num2str(1, '%04i.png')], 'file'),
%     img_files = num2str((1:seq.len)', [img_path '%04i.png']);
% elseif exist([img_path num2str(1, '%04i.jpg')], 'file'),
%     img_files = num2str((1:seq.len)', [img_path '%04i.jpg']);
% elseif exist([img_path num2str(1, '%04i.bmp')], 'file'),
%     img_files = num2str((1:seq.len)', [img_path '%04i.bmp']);
% else
%     error('No image files to load.')
% end
img_files = dir(fullfile(img_path, '*.jpg'));
for i=1:seq.len
img_file{i} = [img_path img_files(i).name];
end
% seq.s_frames = cellstr(img_file);

seq.s_frames = (img_file);
end

