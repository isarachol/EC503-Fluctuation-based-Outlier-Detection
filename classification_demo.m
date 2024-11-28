% function [outputArg1,outputArg2] = main(GraphNumber,k)
close all
clear
rng('default')
%% cd
dataset_name = "PNDB";
addpath 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\EC503-Fluctuation-based-Outlier-Detection'
dataset_directory = "C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Datasets\" + dataset_name;
graph_directory = 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Graph\';
cd(dataset_directory);

%% load data
dataset_num = 10;
file_name = dataset_name + num2str(dataset_num) + ".mat";
label_name =  dataset_name + num2str(dataset_num) + "_labels.mat";
n_max = 300;
% tic
X = load(file_name).Dataset;  % Dataset
y = load(label_name).Labels; % Labels
[n, ~] = size(X);

if n>n_max % limit data to n_max points
    n = n_max;
    X = X(1:n, :);
    y = y(1:n, 1);
end
fprintf("Performance on dataset " + dataset_name + num2str(dataset_num) + "\n");
fprintf("Using %d data points\n", n);

%% FBOD
% hyper parameter
GraphNumber=10; % # of graphs
k=60; % # of neighbors
Abnormal_number=ceil(n*0.1); %abnormal number (how to select this number?)
ADLabels=y; % difference between Label and ADLabels?
cd (graph_directory)
delete *.txt

% no class separation
GG_RandomLink(X,GraphNumber,k, 'test_PNDB_'); % save txt files to \Graph
[value_outlier,index_outlier,OF] = FVP(X',GraphNumber, 'test_PNDB_');

%% Evaluating performance
% auc = EvaluatePerformance(OF,Abnormal_number,ADLabels,y,index_outlier);

figure()
plot(1:n, value_outlier)
title("Outlier Factors in Ascending Order");

% toc
ODA_AbnormalObject_Number=index_outlier(n-Abnormal_number+1:end,:); %last Abnorm number are abnormal
Normal_index_0=index_outlier(1:n-Abnormal_number,:); %the rest is normal

X_filtered = X(Normal_index_0,:);
y_filtered = y(Normal_index_0,:);

%% Train SVM
disp("Results for raw dataset");
[theta, y_train_pred, COST, CCR_train, iteration_x] = Train_SSGD_SVM(X, y, 0, 1);
disp("Results for filtered dataset (filtered out " + num2str(Abnormal_number) + " points)");
[theta_f, y_f_train_pred, COST_f, CCR_f_train, iteration_f_x] = Train_SSGD_SVM(X_filtered, y_filtered, 0, 1);


%% Separate classes
X_0 = X(y==0,:);
X_1 = X(y==1,:);
n_0 = size(X_0,1);
n_1 = n - n_0;

%% FBOD
GG_RandomLink(X_0,GraphNumber,k, 'PNDB_cs0_'); % save txt files to \Graph
[value_outlier_0,index_outlier_0,OF_0] = FVP(X_0',GraphNumber, 'PNDB_cs0_');
GG_RandomLink(X_1,GraphNumber,k, 'PNDB_cs1_'); % save txt files to \Graph
[value_outlier_1,index_outlier_1,OF_1] = FVP(X_1',GraphNumber,'PNDB_cs1_');

%% Evaluating performance

figure()
plot(1:n_0, value_outlier_0)
title("Outlier Factors in Ascending Order y==0");
figure()
plot(1:n_1, value_outlier_1)
title("Outlier Factors in Ascending Order y==1");

toc
% ODA_AbnormalObject_Number=index_outlier(n-Abnormal_number+1:end,:); %last Abnorm number are abnormal
Normal_index_0=index_outlier_0(1:n_0-Abnormal_number,:); %the rest is normal

X_0_filtered = X_0(Normal_index_0,:);
% y_0_filtered = y_0(Normal_index_0,:);

X_sep_f = [X_0_filtered; X_1];
y_sep_f = [zeros(size(X_0_filtered, 1),1); ones(n_1, 1)];

%% Train SVM
disp("Results for separately filtered dataset (filtered out " + num2str(Abnormal_number) + " points)");
[theta_sep, y_sep_train_pred, COST_sep, CCR_sep_train, iteration_sep_x] = Train_SSGD_SVM(X_sep_f, y_sep_f, 0, 1);
% end