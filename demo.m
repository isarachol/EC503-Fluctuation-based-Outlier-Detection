function [outputArg1,outputArg2] = main(GraphNumber,k)
rng('default')
%% cd
addpath 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\EC503-Fluctuation-based-Outlier-Detection'
dataset_directory = 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Datasets';
graph_directory = 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Graph\';
cd(dataset_directory);
%% load data
file_name = 'PNDB.mat';
label_name = 'PNDB_labels.mat';
n_max = 300;
tic
load(file_name);  % Dataset
load(label_name); % Labels
X = [Dataset, Labels];
[n, ~] = size(X);
if n>n_max % limit data to n_max points
    n = n_max;
    X = X(1:n, :);
end
fprintf("Using %d data points\n", n);
%% FBOD
%hyper parameter
GraphNumber=10;
k=60;
Abnormal_number=20; %abnormal number (how to select this number?)
ADLabels=Labels; % difference between Label and ADLabels?
cd (graph_directory)
delete *.txt
GG_RandomLink(X,GraphNumber,k); % save txt files to \Graph
[value_outlier,index_outlier] = FVP(X',GraphNumber,Abnormal_number,ADLabels,Labels,k);
toc
disp(index_outlier(1:10))
end