% modelfile = 'HOGmodel_adam_tensorflow_new.h5';
% 
% modelfile = 'HOGmodel_adam.json';
% weights = 'HOGmodel_adam_tensorflow_new.h5';
% 
% layers = importKerasLayers(modelfile,'ImportWeights',true, ...
%       'WeightFile',weights,'OutputLayerType','classification')

modelfile = 'digitsDAGnet.h5';
layers = importKerasLayers(modelfile)

digitDatasetPath = fullfile(toolboxdir('nnet'),'nndemos', ...
                  'nndatasets','DigitDataset');
digitData = imageDatastore(digitDatasetPath, ...
          'IncludeSubfolders',true,'LabelSource','foldernames');