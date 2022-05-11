function [] = FeatureValuePropagation(X,GraphNumber,Abnormal_number,ADLabels,Label,k)
[m,n]=size(X);
for i=1:GraphNumber
    fileName = ['A_test_SuiJiLink_' num2str(i)  '.txt'];
    A=load(fileName);
    tic
    Z=X*A;
    test=sum(X);
    test_demo=sum(Z);
    fluction(:,i)=(test./test_demo)';
end
ChangeRate=sum(fluction,2);
for ii=1:n
    Nk=find(A(:,ii)~=0);
    OF(ii,:)=sum(abs(ChangeRate(ii,:)-ChangeRate(Nk,:))) ;
end
toc

[value_outlier,index_outlier]=sort(OF);
auc = Measure_AUC(OF, ADLabels);
disp(auc)
 



 %performance metric
 ODA_AbnormalObject_Number=index_outlier(n-Abnormal_number+1:end,:);
ODA_NormalObject_Number=index_outlier(1:n-Abnormal_number,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[Real_NormalObject_Number,Real_Normal]=find(Label==0);
[Real_AbnormalObject_Number,Real_Abnormal]=find(Label==1);

TP=length(intersect(Real_AbnormalObject_Number,ODA_AbnormalObject_Number));
FP=length(Real_AbnormalObject_Number)-TP;
TN=length(intersect(Real_NormalObject_Number,ODA_NormalObject_Number));
FN=length(Real_NormalObject_Number)-TN;


ACC=(TP+TN)/(TP+TN+FP+FN);
fprintf('ACC= %8.5f\n',ACC*100)

DR=TP/(TP+FN);
fprintf('DR= %8.5f\n',DR*100)

P=TP/(TP+FP);
fprintf('P= %8.5f\n',P*100)

FAR=FP/(TN+FP);
fprintf('FAR= %8.5f\n',FAR*100)


end

