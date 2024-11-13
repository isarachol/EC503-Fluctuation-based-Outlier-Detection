function [outputArg1,outputArg2] = main(GraphNumber,k)
%% cd
dataset_directory = 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Datasets';
graph_directory = 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Graph\';
cd(dataset_directory);
%% load data
file_name = 'PNDB.mat';
n_max = 1000;
tic
X = load(file_name).Dataset;
[n, ~] = size(X);
if n>n_max % limit data to n_max points
    n = n_max;
    X = X(1:n, :);
end
fprintf("Using %d data points", n);
%% FBOD
%hyper parameter
GraphNumber=10;
k=60;
Abnormal_number=20; %abnormal number (how to select this number?)
Label=load('PNDB_labels.mat').Labels;
ADLabels=load('PNDB_labels.mat').Labels; % difference between Label and ADLabels?
cd (graph_directory)
delete *.txt
GG_RandomLink(X,GraphNumber,k); % save txt files to \Graph
FVP(X',GraphNumber,Abnormal_number,ADLabels,Label,k);
toc
end