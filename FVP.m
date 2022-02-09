function [] = FeatureValuePropagation(X,GraphNumber,Abnormal_number,ADLabels,Label,k)
[m,n]=size(X);
% tic
for i=1:GraphNumber
    fileName = ['A_test_SuiJiLink_' num2str(i)  '.txt'];%%%%%注意，这个名字也要改一下。
    A=load(fileName);
    tic
    Z=X*A;
    test=sum(X);
    test_demo=sum(Z);
    fluction(:,i)=(test./test_demo)';
% fluction(:,i)=(test_demo./test)';
% fluction=sum(Z-X);
end
%再次尝试一种计算OF值的方法
%假设正常对象与离群点的波动程度不同，那么继续依照连接关系，计算它们的波动值之间的差异，差异越大，越有可能是离群点。
%
ChangeRate=sum(fluction,2);

% for ii=1:n
%     for j=1:k
%         Nk=find(A(:,ii)~=0);
%         diff(ii,j) = abs(ChangeRate(ii,:)-ChangeRate(Nk(j,:),:));
%     end
% end

%这两个for循环极大的提高了时间开销
for ii=1:n
    Nk=find(A(:,ii)~=0);
    %第二种提高了计算效率的OF值计算法
    OF(ii,:)=sum(abs(ChangeRate(ii,:)-ChangeRate(Nk,:))) ;
%     OF=OF_test ./ k;
end
toc

% OF=sum(diff,2)./k;


[value_outlier,index_outlier]=sort(OF);

auc = Measure_AUC(OF, ADLabels);
disp(auc)
 



 %性能评价
 ODA_AbnormalObject_Number=index_outlier(n-Abnormal_number+1:end,:);%outlier dGraphNumberection algorithm 算法认定的异常对象的编号
ODA_NormalObject_Number=index_outlier(1:n-Abnormal_number,:);%outlier dGraphNumberection algorithm算法认定的正常对象的编号
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%算法实际的检测率/准确率/误报率等评价指标的计算%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Real_NormalObject_Number表示数据集中真正的正常对象的编号，Real_AbnormalObject_Number表示数据集中真正异常对象的编号
[Real_NormalObject_Number,Real_Normal]=find(Label==0);
[Real_AbnormalObject_Number,Real_Abnormal]=find(Label==1);

%正例是异常对象，反例是正常对象
TP=length(intersect(Real_AbnormalObject_Number,ODA_AbnormalObject_Number));
FP=length(Real_AbnormalObject_Number)-TP;
TN=length(intersect(Real_NormalObject_Number,ODA_NormalObject_Number));
FN=length(Real_NormalObject_Number)-TN;

%准确率
ACC=(TP+TN)/(TP+TN+FP+FN);
fprintf('准确率ACC= %8.5f\n',ACC*100)
%检测率==查全率=R
DR=TP/(TP+FN);
fprintf('检测率DR= %8.5f\n',DR*100)
%查准率P
P=TP/(TP+FP);
fprintf('查准率P= %8.5f\n',P*100)
%误报率
FAR=FP/(TN+FP);
fprintf('误报率FAR= %8.5f\n',FAR*100)


% if DR< 66.66
% demo(100,1)
% end
end

