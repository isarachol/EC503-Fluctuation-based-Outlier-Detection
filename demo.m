function [outputArg1,outputArg2] = main(GraphNumber,k)
X=load('Normalization_wine.txt');
%hyper parameter
GraphNumber=10;
k=60;
Abnormal_number=20;%abnormal number (how to select this number?)
Label=load('Label_wine.txt');
ADLabels=load('Label_wine.txt');
cd ('C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Graph\')
delete *.txt
GG_RandomLink(X,GraphNumber,k); % save txt files to Fluctuation-based-Outlier-Detection-main\Graph
FVP(X',GraphNumber,Abnormal_number,ADLabels,Label,k);
end