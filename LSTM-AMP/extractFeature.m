function feat  = extractFeature(im, pos, window_sz, cos_window, indLayers,params)

% Get the search window from previous detection
patch = get_subwindow(im, pos, window_sz);

feat  = get_features(patch, cos_window, indLayers,params);

end