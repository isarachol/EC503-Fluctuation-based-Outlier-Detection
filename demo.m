function [outputArg1,outputArg2] = main(GraphNumber,k)
dataset_directory = 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Datasets';
graph_directory = 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Graph\';
cd(dataset_directory);
file_name = 'Covid Data.csv';
n = 100;
tic
X = extract_dataset_csv(file_name, n, 'Covid Data.mat');
%hyper parameter
GraphNumber=10;
k=60;
Abnormal_number=20; %abnormal number (how to select this number?)
Label=load('Label_wine.txt');
ADLabels=load('Label_wine.txt');
cd (graph_directory)
delete *.txt
GG_RandomLink(X,GraphNumber,k); % save txt files to Fluctuation-based-Outlier-Detection-main\Graph
FVP(X',GraphNumber,Abnormal_number,ADLabels,Label,k);
toc
end