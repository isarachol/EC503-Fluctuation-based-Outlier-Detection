% Combining features with labels (consider labels as another feature) when
% performing outlier detection, then filter out the outliers and perform
% SVM on unfiltered and filtered data to compare

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
dataset_num = 70;
file_name = dataset_name + num2str(dataset_num) + ".mat";
label_name =  dataset_name + num2str(dataset_num) + "_labels.mat";
n_max = 500;
% tic
X = load(file_name).Dataset;  % Dataset
y = load(label_name).Labels; % Labels
[n, dim] = size(X);

if n>n_max % limit data to n_max points
    n = n_max;
    X = X(1:n, :);
    y = y(1:n, 1);
end
X_combined = [X,y];
fprintf("Method: Use labels as feature to find outliers");
fprintf("Performance on dataset " + dataset_name + num2str(dataset_num) + "\n");
fprintf("Using %d data points\n", n);

%% FBOD
% hyper parameter
GraphNumber=10; % # of graphs
k=60; % # of neighbors
Abnormal_number=ceil(n*0.2); %abnormal number (how to select this number?)
% ADLabels=y;
cd (graph_directory)
delete *.txt

% no class separation
% GG_RandomLink(X_combined,GraphNumber,k, 'test_PNDB_'); % save txt files to \Graph
[value_outlier,index_outlier,OF] = FBOD(X_combined,y,GraphNumber,k, 'test_PNDB_');

%% Evaluating performance
% auc = EvaluatePerformance(OF,Abnormal_number,ADLabels,y,index_outlier);

%% Train SVM
[X_filtered, y_filtered] = filter_outliers(X, y, index_outlier, Abnormal_number);
disp("Results for raw dataset");
[theta, y_train_pred, COST, CCR_train, iteration_x] = Train_SSGD_SVM(X, y, 0, 1);
disp('CCR: '), disp(CCR_train(end)),
disp("Results for filtered dataset (filtered out " + num2str(Abnormal_number) + " points)");
[theta_f, y_f_train_pred, COST_f, CCR_f_train, iteration_f_x] = Train_SSGD_SVM(X_filtered, y_filtered, 0, 1);
disp('CCR: '), disp(CCR_f_train(end)),

%% cross validation
best_abnor_num = 0;
CCR_best = CCR_train(end);
CCR_cross = [];
theta_f_best = theta;
for i=1:10:floor(n_max/2)
    [X_f_best, y_f_best] = filter_outliers(X, y, index_outlier, i);
    [theta_f_cross, ~, ~, CCR_f_best, ~] = Train_SSGD_SVM(X_f_best, y_f_best, 0, 1);
    CCR = CCR_f_best(end);
    CCR_cross = [CCR_cross, CCR];
    if CCR>CCR_best
        CCR_best = CCR;
        best_abnor_num = i;
        theta_f_best = theta_f_cross;
    end
end

disp("Results for best filtered dataset (filtered out " + num2str(best_abnor_num) + " points)")
disp('CCR: '), disp(CCR_best),

figure()
subplot(1,2,1)
plot(1:n, value_outlier)
title("Outlier Factors in Ascending Order #" + num2str(dataset_num));
xlabel("Data point (point 1 - point n)");
ylabel("Outlier factor");
subplot(1,2,2)
plot(1:10:floor(n_max/2), CCR_cross)
title("CCR as number of (outlier) elimination changes #" + num2str(dataset_num))
xlabel("Number of outlier eliminations");
ylabel("CCR");

% end