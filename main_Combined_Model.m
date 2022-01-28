clear all;
clc;

[m f m_full]=xlsread('xlsx file, patient list with clinical variables');

im=load('Head CT pre-processed data direction'); % load pre-processed sub-volume Head CT images (7 slices spanning the midpoint of the body of the lateral ventricles to the midbrain) with slice-thickness=5 
Mode="Mortality"; % Prediction mode: select "Mortality" or "Unfavorable"

if Mode=="Mortality"
load('Imaging Model_Mortality.mat');
net_cnn=net;
load('Clinical_Model_mortality.mat');
load('Combined_Model_mortality.matt');

elseif Mode=="Unfavorable"
load('Imaging Model_Unfavorable.mat');
net_cnn=net;
load('Clinical_Model_unfavorable.mat');
load('Combined_Model_unfavorable.mat');

end
%Clinical inputs={'Pupil' 'GCS' 'GMS' 'Hypoxia' 'Hypotension' 'Marshal CT' 'tsah' 'Epidural' 'Glucose' 'Hb' 'age' 'race' 'sex' 'MoI'}; 
feature_row= []; %Insert the column index for each clinical input in order, for example: [1 7 8 9 10 11 19 14 15 12 13 2 3 4 5];
x=m_full(2:end,feature_row);
x_clean = x(all(cellfun(@(i)any(~isnan(i)),x),2),:);

im_masked_3D_com= im;

inputSize=net_cnn.Layers(1).InputSize;
augimdsTest = augmentedImageDatastore(inputSize,im_masked_3D_com,ones(size(im_masked_3D_com,4),1));

X_test=cell2mat(x_clean);
   for k=1:size(X_test,1)
       X_test_r(:,1,1,k)=X_test(k,:);
   end

[YPred_test_clinic,probs_test_clinic] = predict(model,X_test);
[YPred_test_imaging,probs_test_imaging] = classify(net_cnn,augimdsTest);

probs_comb=[probs_test_imaging(:,1) probs_test_clinic(:,1)];
[predict_label_comb, probs_comb] = predict(model_com, probs_comb); % probs: Probabiity value of Mortality or Unfavorable outcome predictions




