function [params, state]=init_scale_para(im_gray, target_sz, pos,angl,params,state)

im_sz=size(im_gray);
padding=1.8;
cell_size=4;

if target_sz(1)/target_sz(2)>2
    window_sz = floor(target_sz.*[1.4, 1+padding]);
elseif min(target_sz)>80 && prod(target_sz)/prod(im_sz(1:2))>0.1
    window_sz=floor(target_sz*2);

else        
    window_sz = floor(target_sz * (1 + padding));
end

state.app_sz=target_sz+2*cell_size;

nScales=33;%1100
scale_sigma_factor=1/4;
scale_sigma = nScales/sqrt(33) * scale_sigma_factor;
ss = (1:nScales) - ceil(nScales/2);
ys = exp(-0.5 * (ss.^2) / scale_sigma^2);
state.ysf = single(fft(ys));

scale_step = 1.01;
ss = 1:nScales;
state.scaleFactors = scale_step.^(ceil(nScales/2) - ss);
%     currentScaleFactor = 1;

state.app_sz=state.app_sz;


if mod(nScales,2) == 0
    scale_window = single(hann(nScales+1));
    scale_window = scale_window(2:end);
else
    scale_window = single(hann(nScales));
end;

state.scale_window=scale_window;

scale_model_max_area = 512;
scale_model_factor = 1;
if prod(state.app_sz) > scale_model_max_area
    scale_model_factor = sqrt(scale_model_max_area/prod(state.app_sz));
end
state.scale_model_sz = floor(state.app_sz * scale_model_factor);
state.lambda=0.01;
state.interp_factor=0.01;

state.min_scale_factor = scale_step ^ ceil(log(max(5 ./ window_sz)) / log(scale_step));
state.max_scale_factor = scale_step ^ floor(log(min(im_sz(1:2)./ target_sz)) / log(scale_step));


%============my work========================
scaleFactors1=zeros([1 length(angl)*nScales]);
scale_window1=zeros([length(angl)*nScales 1]);
count=0;
for i=1:length(angl):length(angl)*nScales
    count=count+1;
    scaleFactors1(1,i:i+6)=state.scaleFactors(1,count);
    scale_window1(i:i+6,1)=state.scale_window(count,1);
end
state.scaleFactors1=scaleFactors1;
state.scale_window1=scale_window1;
%============================================


[xs xs1]= get_scale_sample(im_gray, pos, state.app_sz, state.scaleFactors, state.scale_window, state.scale_model_sz,angl);


ysf1=zeros(1,nScales);
c=0;
for i=1:length(angl):nScales*length(angl)
    c=c+1;
    ysf1(1,i:(i+length(angl)-1))=state.ysf(c);
end
state.ysf1=ysf1;

% calculate the scale filter update
xsf = fft(xs,[],2); %775*231
state.sf_num = bsxfun(@times, state.ysf, conj(xsf));
state.sf_den = sum(xsf .* conj(xsf), 1);

end

