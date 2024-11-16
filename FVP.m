% Perform FVP and Find Outliers Factors
function [] = FeatureValuePropagation(X,GraphNumber,Abnormal_number,ADLabels,Label,k)
[m,n]=size(X); %m = dimensions, n = number of points
for i=1:GraphNumber
    fileName = ['A_test_SuiJiLink_' num2str(i)  '.txt']; % result from GG_RandomLink.m
    A=load(fileName); 
    %tic measure in demo instead
    Z=X*A; % get some features from X based on the random Link
    test=sum(X); % 1 x m = all features combined to one
    test_demo=sum(Z); % all features of k neighbors and xi combined to one
    fluction(:,i)=(test./test_demo)'; % sum(xi) / sum(xi + neighbors)
end
ChangeRate=sum(fluction,2); % sum of fluctuations from different graph generations (1 x m)

for ii=1:n % for each data point
    Nk=find(A(:,ii)~=0); % k+1 values of a point and neighbors
    OF(ii,:)=sum(abs(ChangeRate(ii,:)-ChangeRate(Nk,:))); % sum of (fluc xi - flux neighbors)
end
%toc measure in demo instead

[value_outlier,index_outlier]=sort(OF); % default ascending
auc = Measure_AUC(OF, ADLabels);
fprintf('AUC= %8.5f\n',auc*100);


 %performance metric
ODA_AbnormalObject_Number=index_outlier(n-Abnormal_number+1:end,:); %last Abnorm number are abnormal
ODA_NormalObject_Number=index_outlier(1:n-Abnormal_number,:); %the rest is normal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[Real_NormalObject_Number,Real_Normal]=find(Label==0); % labels 0 are negative samples (outliers)
[Real_AbnormalObject_Number,Real_Abnormal]=find(Label==1);

% T for true (correct), F for fault
% P for abnormal, N for normal (marked as)
TP=length(intersect(Real_AbnormalObject_Number,ODA_AbnormalObject_Number)); % out corr marked as out
FP=length(Real_AbnormalObject_Number)-TP; % # out not found (matlab) % norm incorr marked as outl (paper)
TN=length(intersect(Real_NormalObject_Number,ODA_NormalObject_Number)); % norm corr marked as norm
FN=length(Real_NormalObject_Number)-TN; % # norm not found (matlab) % out incorr marked as norm (paper)


ACC=(TP+TN)/(TP+TN+FP+FN); % accuracy
fprintf('ACC= %8.5f\n',ACC*100)

DR=TP/(TP+FN); % detection rate = detected out / all out
fprintf('DR= %8.5f\n',DR*100)

P=TP/(TP+FP); % detected out / all detected as out (right + wrong outs)
fprintf('P= %8.5f\n',P*100)

FAR=FP/(TN+FP); % false alarm rate
fprintf('FAR= %8.5f\n',FAR*100)


end

