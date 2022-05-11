function [outputArg1,outputArg2] = main(GraphNumber,k)
X=load('Normalization_wbc.txt');
%hyper parameter
GraphNumber=2;
k=10;
Abnormal_number=20;%abnormal number
Label=load('Label_wbc.txt');
ADLabels=load('Label_wbc.txt');
cd ('D:\matlab2019a\matlab files\FVP\Tabular Outlier Detection\Graph')
delete *.txt
GG_RandomLink(X,GraphNumber,k);
FVP(X',GraphNumber,Abnormal_number,ADLabels,Label,k);
end