function [seq, ground_truth,video_path] = load_video_info_monika(video_path,vid)

% ground_truth = dlmread([video_path '/gt.txt']);
v_path='/home/arjun18023/Thesis/Datasets/UAV123/anno/UAV123';
ground_truth = dlmread([v_path '/' vid '.txt']);

seq.len = size(ground_truth, 1);
seq.init_rect = ground_truth(1,:);

% img_path = [video_path '/img/'];
img_path = [video_path ];

img_files = dir(fullfile(img_path, '*.jpg'));
if size(img_files,1)==0
img_files = dir(fullfile(img_path, '*.png'));
end
% img_files = img_files(4:end);
img_files = {img_files.name};
% img_files = [img_path img_files];
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

video_path=['/NasShare2/Monika/Dataset_UAV123/UAV123/data_seq/UAV123/',vid,'/'];
seq.s_frames = cellstr(img_file);

end

