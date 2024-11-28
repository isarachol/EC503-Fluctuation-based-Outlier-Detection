% Evaluating performance of the outlier detection given number of outliers
function [auc] = EvaluatePerformance(OF,Abnormal_number,ADLabels,Labels,index_outlier)
[n,~] = size(Labels);
auc = Measure_AUC(OF, ADLabels);
fprintf('AUC= %8.5f\n',auc*100);


% performance metric
% ODA_AbnormalObject_Number=index_outlier(n-Abnormal_number+1:end,:); %last Abnorm number are abnormal
% ODA_NormalObject_Number=index_outlier(1:n-Abnormal_number,:); %the rest is normal
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% [Real_NormalObject_Number,Real_Normal]=find(Labels==0); % labels 0 are negative samples (outliers)
% [Real_AbnormalObject_Number,Real_Abnormal]=find(Labels==1);
% 
% % T for true (correct), F for fault
% % P for abnormal, N for normal (marked as)
% TP=length(intersect(Real_AbnormalObject_Number,ODA_AbnormalObject_Number)); % out corr marked as out
% FP=length(Real_AbnormalObject_Number)-TP; % # out not found (matlab) % norm incorr marked as outl (paper)
% TN=length(intersect(Real_NormalObject_Number,ODA_NormalObject_Number)); % norm corr marked as norm
% FN=length(Real_NormalObject_Number)-TN; % # norm not found (matlab) % out incorr marked as norm (paper)
% 
% 
% ACC=(TP+TN)/(TP+TN+FP+FN); % accuracy
% fprintf('ACC= %8.5f\n',ACC*100)
% 
% DR=TP/(TP+FN); % detection rate = detected out / all out
% fprintf('DR= %8.5f\n',DR*100)
% 
% P=TP/(TP+FP); % detected out / all detected as out (right + wrong outs)
% fprintf('P= %8.5f\n',P*100)
% 
% FAR=FP/(TN+FP); % false alarm rate
% fprintf('FAR= %8.5f\n',FAR*100)
end

