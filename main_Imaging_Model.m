
clear all;
clc;
Mode="Mortality"; % Prediction mode: select "Mortality" or "Unfavorable"
im=load('Head CT pre-processed data direction'); % load pre-processed sub-volume Head CT images (7 slices spanning the midpoint of the body of the lateral ventricles to the midbrain) with slice-thickness=5 

if Mode=="Mortality"
 load('Imaging Model_Mortality.mat');
elseif Mode=="Unfavorable"
 load('Imaging Model_Unfavorable.mat');
end

inputSize=net.Layers(1).InputSize;
augimdsTest = augmentedImageDatastore(inputSize,im,ones(size(im),1));

[YPred,probs] = classify(net,augimdsTest); % probs: Probabiity value of Mortality or Unfavorable outcome predictions
