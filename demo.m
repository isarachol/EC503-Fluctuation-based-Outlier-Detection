% function [GraphNumber,k] = demo(inputArg1,inputArg2)
% 
% %%%%%%%采用随机的方式调参
% % X=load('Normalization_glass.txt');
% % [m,n]=size(X);
% % for i=10:m
% %     for j=50:256
% %     k=i;
% %     GraphNumber=j;
% %     fprintf('k=%8.5f,GraphNumber=%8.5f\n',k,GraphNumber)
% %     main(GraphNumber,k);
% %     end
% % end
% X=load('Normalization_lympho.txt');
% [m,n]=size(X);
% Select_Parameter_times=20;
% for i=1:Select_Parameter_times
%     k=randperm(m,1);
% %     GraphNumber=randperm(256,1);%%%%生成从1-256中间的一个随机整数 
%     GraphNumber=2;
%     fprintf('k=%8.5f,GraphNumber=%8.5f\n',k,GraphNumber)
%     main(GraphNumber,k);
% end
% end

function [outputArg1,outputArg2] = main(GraphNumber,k)
% X=load('Normalization_wine.txt');
X=load('Normalization_test.txt');
%两个超参
GraphNumber=2;
k=10;
Abnormal_number=4;%异常样本个数
Label=load('Label_test.txt');
ADLabels=load('Label_test.txt');
%%%%生成图之前，先清空之前生成的图，不然会重复写入。
% delete 'D:\matlab2019a\matlab files\FVP\Graph' '.txt'
cd ('D:\matlab2019a\matlab files\FVP\Tabular Outlier Detection\Graph')
delete *.txt
GG_RandomLink(X,GraphNumber,k);
% tic
FVP(X',GraphNumber,Abnormal_number,ADLabels,Label,k);%这里对X进行了转置
% toc


%%%%%%%必须达到一定的AUC值才停止计算，否则就循环自己



end