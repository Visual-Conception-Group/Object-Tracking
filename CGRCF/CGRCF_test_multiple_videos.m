clc
clear all
close all

setup_path();
% % To Run on TC128 Dataset
base_path   = './Datasets/TC128/'  %Add path of your dataset here
videos{1}='Basketball';
videos{2}='Bicycle';
videos{3}='Biker';
videos{4}='Bird';
videos{5}='Board';
videos{6}='Bolt';
videos{7}='Boy';
videos{8}='CarDark';
videos{9}='CarScale';
videos{10}='Coke';
videos{11}='Couple';
videos{12}='Crossing';
videos{13}='Cup';
videos{14}='David';
videos{15}='David3';
videos{16}='Deer';
videos{17}='Diving';
videos{18}='Doll';
videos{19}='FaceOcc1';
videos{20}='Football1';
videos{21}='Girl';
videos{22}='Girlmov';
videos{23}='Gym';
videos{24}='Hand';
videos{25}='Iceskater';
videos{26}='Ironman';
videos{27}='Jogging1';
videos{28}='Jogging2';
videos{29}='Juice';
videos{30}='Lemming';
videos{31}='Liquor';
videos{32}='Matrix';
videos{33}='MotorRolling';
videos{34}='MountainBike';
videos{35}='Panda';
videos{36}='Shaking';
videos{37}='Singer1';
videos{38}='Singer2';
videos{39}='Skating1';
videos{40}='Skating2';
videos{41}='Skiing';
videos{42}='Soccer';
videos{43}='Subway';
videos{44}='Sunshade';
videos{45}='Tiger1';
videos{46}='Tiger2';
videos{47}='Torus';
videos{48}='Trellis';
videos{49}='Walking';
videos{50}='Walking2';
videos{51}='Woman';
videos{52}='Airport_ce';
videos{53}='Baby_ce';
videos{54}='Badminton_ce1';
videos{55}='Badminton_ce2';
videos{56}='Basketball_ce1';
videos{57}='Basketball_ce2';
videos{58}='Basketball_ce3';
videos{59}='Bike_ce1';
videos{60}='Bike_ce2';
videos{61}='Bikeshow_ce';
videos{62}='Boat_ce1';
videos{63}='Boat_ce2';
videos{64}='Busstation_ce1';
videos{65}='Busstation_ce2';
videos{66}='Carchasing_ce1';
videos{67}='Carchasing_ce3';
videos{68}='Carchasing_ce4';
videos{69}='Eagle_ce';
videos{70}='Electricalbike_ce';
videos{71}='Face_ce';
videos{72}='Guitar_ce1';
videos{73}='Guitar_ce2';
videos{74}='Hurdle_ce1';
videos{75}='Hurdle_ce2';
videos{76}='Kite_ce1';
videos{77}='Kite_ce2';
videos{78}='Kite_ce3';
videos{79}='Kobe_ce';
videos{80}='Logo_ce';
videos{81}='Messi_ce';
videos{82}='Michaeljackson_ce';
videos{83}='Motorbike_ce';
videos{84}='Plane_ce2';
videos{85}='Railwaystation_ce';
videos{86}='Singer_ce1';
videos{87}='Singer_ce2';
videos{88}='Skating_ce1';
videos{89}='Skating_ce2';
videos{90}='Skiing_ce';
videos{91}='Skyjumping_ce';
videos{92}='Spiderman_ce';
videos{93}='Suitcase_ce';
videos{94}='Surf_ce1';
videos{95}='Surf_ce2';
videos{96}='Surf_ce3';
videos{97}='Surf_ce4';
videos{98}='Tennis_ce1';
videos{99}='Tennis_ce2';
videos{100}='Tennis_ce3';
videos{101}='Toyplane_ce';
videos{102}='Ball_ce1';
videos{103}='Ball_ce2';
videos{104}='Ball_ce3';
videos{105}='Ball_ce4';
videos{106}='Bee_ce';
videos{107}='Charger_ce';
videos{108}='Cup_ce';
videos{109}='Face_ce2';
videos{110}='Fish_ce1';
videos{111}='Fish_ce2';
videos{112}='Hand_ce1';
videos{113}='Hand_ce2';
videos{114}='Microphone_ce1';
videos{115}='Microphone_ce2';
videos{116}='Plate_ce1';
videos{117}='Plate_ce2';
videos{118}='Pool_ce1';
videos{119}='Pool_ce2';
videos{120}='Pool_ce3';
videos{121}='Ring_ce';
videos{122}='Sailor_ce';
videos{123}='SuperMario_ce';
videos{124}='TableTennis_ce';
videos{125}='TennisBall_ce';
videos{126}='Thunder_ce';
videos{127}='Yo-yos_ce1';
videos{128}='Yo-yos_ce2';
videos{129}='Yo-yos_ce3';


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
    video_path = [base_path videos{vid}];
    [seq, ground_truth,video_path] = load_video_info(video_path,videos{vid});
    region=seq.init_rect;
    names=seq.s_frames;
    [state, ~, params] = tracker_Proposed_initialize(imread(names{1}), region, params);
    addpath /external/matconvnet/matlab
%     vl_compilenn('enableGpu',true,'cudaRoot', '/usr/local/cuda-8.0')
    vl_setupnn
    state.rect_position = zeros(10, 4);
    state.rects = zeros(10, 4);
    
    for i=1:seq.len       
        im= imread(names{i});
        [state, region] = Proposed_optimized(state,im, params);
        state.frame = state.frame + 1; %avot2017
    end
    results.res = state.rect_position;
    result=round(results.res);
    fname1=['./Results/TC128/',videos{vid},'_RGB.txt'];
    dlmwrite(fname1,result)
end
