clear all;
clc;
Mode="Mortality"; % Prediction mode: select "Mortality" or "Unfavorable"
[m f m_full]=xlsread('.\TRACK Reformatted_updated3.xlsx');

if Mode=="Mortality"
 net_clinic='Clinical_Model_mortality.mat';
elseif Mode=="Unfavorable"
 net_clinic='Clinical_Model_unfavorable.mat';
end

load(net_clinic);
%Clinical inputs={'Pupil' 'GCS' 'GMS' 'Hypoxia' 'Hypotension' 'Marshal CT' 'tsah' 'Epidural' 'Glucose' 'Hb' 'age' 'race' 'sex' 'MoI'}; 
feature_row= []; %Insert the column index for each clinical input in order, for example: [1 7 8 9 10 11 19 14 15 12 13 2 3 4 5];
x=m_full(2:end,feature_row);
x_clean = x(all(cellfun(@(i)any(~isnan(i)),x),2),:);
X_test=cell2mat(x_clean(:,2:end));


   for k=1:size(X_test,1)
       X_test_r(:,1,1,k)=X_test(k,:);
   end

[YPred,probs] = predict(model, X_test); % probs: Probabiity value of Mortality or Unfavorable outcome predictions

