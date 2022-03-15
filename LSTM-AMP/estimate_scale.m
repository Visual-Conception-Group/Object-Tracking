function [currentScaleFactor, recovered_angle] = estimate_scale( im_gray, pos, currentScaleFactor,angl,params,state)
recovered_angle=0;


% extract the test sample feature map for the scale filter
[xs xs1] = get_scale_sample(im_gray, pos, state.app_sz, state.scaleFactors*currentScaleFactor, state.scale_window, state.scale_model_sz,angl);

% calculate the correlation response of the scale filter
xsf = fft(xs,[],2);
scale_response = real(ifft(sum(state.sf_num .* xsf, 1) ./ (state.sf_den + state.lambda)));

% find the maximum scale response
recovered_scale = find(scale_response == max(scale_response(:)), 1);

currentScaleFactor = currentScaleFactor*state.scaleFactors(recovered_scale);
if currentScaleFactor < state.min_scale_factor
    currentScaleFactor = state.min_scale_factor;
elseif currentScaleFactor > state.max_scale_factor
    currentScaleFactor = state.max_scale_factor;
end

% update the scale model
%===========================
% extract the training sample feature map for the scale filter
[xs xs1] = get_scale_sample(im_gray, pos, state.app_sz, currentScaleFactor * state.scaleFactors, state.scale_window, state.scale_model_sz,angl);

% calculate the scale filter update
xsf = fft(xs,[],2);
new_sf_num = bsxfun(@times, state.ysf, conj(xsf));
new_sf_den = sum(xsf .* conj(xsf), 1);

state.sf_den = (1 - state.interp_factor) * state.sf_den + state.interp_factor * new_sf_den;
state.sf_num = (1 - state.interp_factor) * state.sf_num + state.interp_factor * new_sf_num;


end

