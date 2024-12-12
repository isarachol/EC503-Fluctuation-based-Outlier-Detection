%% visualize dataset
close all
clear
clc
rng('default')

%% cd
dataset_name = "PNDB";
addpath 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\EC503-Fluctuation-based-Outlier-Detection'
dataset_directory = "C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Datasets\" + dataset_name;
graph_directory = 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Graph\';
cd(dataset_directory);


%% load data
dataset_num = 70;
file_name = dataset_name + ".mat";
label_name =  dataset_name + num2str(dataset_num) + "_labels.mat";


% tic
X = load(file_name).Dataset;  % Dataset
y = load(label_name).Labels; % Labels
[n, dim] = size(X);
X_combined = [X,y];
y1=0;
y2=1;

varNames = ["Age","HbA1c","Genetic Info","Family History","Birth Weight", "Developmental Delay", "Insulin Level"];
gplotmatrix(X,[],y,[],[],8,[],[],varNames)
title("PNDM " + num2str(dataset_num))


%% load data

dataset_name = "iris";
addpath 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\EC503-Fluctuation-based-Outlier-Detection'
dataset_directory = "C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Datasets\" + dataset_name;
graph_directory = 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Graph\';
cd(dataset_directory);

file_name = dataset_name + ".mat";

y1=1;
y2=2;
X_train = load(file_name).X_data_train;
y_train = load(file_name).Y_label_train;
X_train = X_train(1:70,:);
y_train = y_train(1:70,:);
X_test = load(file_name).X_data_test;
y_test = load(file_name).Y_label_test;
X_test1 = X_test(y_test == y1, :);
X_test2 = X_test(y_test == y2, :);
X_test = [X_test1; X_test2];
y_test = y_test(1:30);

gplotmatrix(X_train,[],y_train)
title("iris")