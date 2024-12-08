% Combining features with labels (consider labels as another feature) when
% performing outlier detection, then filter out the outliers and perform
% SVM on unfiltered and filtered data to compare
% Note: SVM doesn't really work on mnist data. It's not linearly separable

close all
clear
clc
rng('default')

%% cd
dataset_name = "mnist_reshaped";
addpath 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\EC503-Fluctuation-based-Outlier-Detection'
dataset_directory = "C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Datasets\" + dataset_name;
graph_directory = 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Graph\';
cd(dataset_directory);

%% load data
file_name = dataset_name + ".mat";
img_size = [28, 28];
% tic
X_train = load(file_name).trainimages;  % Dataset
y_train = load(file_name).trainLabels; % Labels
X_test = load(file_name).testimages;  % Dataset
y_test = load(file_name).testLabels; % Labels
% X_combined = [X,y];
% y0=0;
y1=0;
y2=1;
y_outlier=2;

%% Extract 0, 1, and 2 --> they are sifficiently diffrent in my oponion
X_train0 = X_train(y_train==y1,:);
X_train1 = X_train(y_train==y2,:);
X_train2 = X_train(y_train==y_outlier,:); % outliers
n_per_class_train = 500;
n_per_class_test = 100;
outlier_ratio = 0.2;
n_outlier = 2*n_per_class_train * outlier_ratio/(1-outlier_ratio);

X_train_raw = [X_train0(1:n_per_class_train,:); X_train1(1:n_per_class_train,:)];
[n_train_raw, dim] = size(X_train_raw);
X_train = [X_train_raw; X_train2(1:n_outlier,:)];
y_train = [zeros(n_per_class_train, 1); ones(n_per_class_train,1); randi([0, 1], [n_outlier,1])];
n_train = length(y_train);

% for testing
X_test0 = X_test(y_test==y1,:);
X_test1 = X_test(y_test==y2,:);
X_test = [X_test0(1:n_per_class_test,:); X_test1(1:n_per_class_test,:)];
y_test = [zeros(n_per_class_test, 1); ones(n_per_class_test,1)];

%% FBOD parameters
% hyper parameter
GraphNumber=10; % # of graphs
NeighborNumber=60; % # of neighbors
cd (graph_directory)
delete *.txt

%% FBOD and Filter training dataset
X_combined_train = [X_train, y_train];
[value_outlier,index_outlier,OF] = FBOD(X_combined_train,GraphNumber,NeighborNumber, 'train_mnist_');
% threshold_correct = value_outlier(n_train_old);
% [X_filtered, y_filtered, value_without_outlier, Abnormal_number] = filter_outliers(X_train, ...
%     y_train, value_outlier, index_outlier, threshold_correct);

%% Train SVM on Raw data
fprintf("\nSVM on Dataset + Outliers");
disp("Results for raw dataset");
[theta, y_train_pred, COST, CCR_train, iteration_x] = Train_SSGD_SVM(X_train, y_train, y1, y2);
disp("CCR: " + num2str(CCR_train(end)))
% disp("Results for filtered dataset (filtered out " + num2str(Abnormal_number_train) + " points)");
% [theta_f, y_f_train_pred, COST_f, CCR_f_train, iteration_f_x] = Train_SSGD_SVM(X_filtered, y_filtered, y1, y2);
% disp('CCR: '), disp(CCR_f_train(end)),

%% Validation of Abnormal_number on training dataset
% best_abnor_num = 0;
max_threshold = value_outlier(end);  % max OF value
best_threshold = max_threshold;
min_threshold = value_outlier(floor(n_train/2)); % mid way
CCR_best = CCR_train(end);
CCR_cross = [];
theta_f_best = theta;
Abnormal_number_best = 0;
for i=linspace(max_threshold, min_threshold, 10) % 30 validation points
    if i<4.38
        a = 0;
    end
    [X_f_best, y_f_best, ~, Abnormal_number] = filter_outliers(X_train, y_train, value_outlier, index_outlier, i);
    [theta_f_cross, ~, ~, CCR_f_best, ~] = Train_SSGD_SVM(X_f_best, y_f_best, 0, 1);
    CCR = CCR_f_best(end);
    CCR_cross = [CCR_cross, CCR];
    if CCR>CCR_best
        CCR_best = CCR;
        % best_abnor_num = i;
        best_threshold = i;
        theta_f_best = theta_f_cross;
        Abnormal_number_best = Abnormal_number;
    end
end

%% Visualize results
fprintf("\nValidation: \nSVM on filtered dataset (from Dataset + Outliers)\n");
disp("Result for best OF threshold: " + num2str(best_threshold))
disp("CCR: " + num2str(CCR_best))
disp("Number of filtered data: " + num2str(Abnormal_number_best))

figure()
subplot(1,2,1)
plot(1:n_train, value_outlier)
title("Outlier Factors in Ascending Order #" + dataset_name);
xlabel("Data point (point 1 - point n)");
ylabel("Outlier factor");
subplot(1,2,2)
plot(linspace(max_threshold, min_threshold, 10), CCR_cross)
title("CCR as threshold decreases #" + dataset_name)
xlabel("threshold");
ylabel("CCR");

%% Testing
% Testing with theta from dataset with outliers
X_raw_TEST = [X_test(y_test==y1,:);X_test(y_test==y2,:)];
Y_raw_TEST = [-1*ones(size(X_test(y_test==y1,:),1),1);+1*ones(size(X_test(y_test==y2,:),1),1)];
X_raw_test_ext = [X_raw_TEST,ones(size(X_raw_TEST,1),1)];

fprintf("\nTesting: ");
fprintf("\n")
condition_test = double((X_raw_test_ext*theta).*Y_raw_TEST>0);
ccr_test = 1/length(X_raw_test_ext)*sum(condition_test);
disp("Testing CCR (raw): " + num2str(ccr_test));

% filtered testing data
% X_fil_TEST = [X_test(y_test==y1,:);X_test(y_test==y2,:)];
% Y_fil_TEST = [-1*ones(length(X_test(y_test==y1,:)),1);+1*ones(length(X_test(y_test==y2,:)),1)];
% X_fil_test_ext = [X_fil_TEST,ones(length(X_fil_TEST),1)];
% 
% condition_test = double((X_fil_test_ext*theta_f).*Y_fil_TEST>0);
% ccr_fil_test = 1/length(X_fil_test_ext)*sum(condition_test);
% disp("Testing CCR (filtered at correct threshold): " + num2str(ccr_fil_test));

% Testing with theta from validation
X_fil_TEST = [X_test(y_test==y1,:);X_test(y_test==y2,:)];
Y_fil_TEST = [-1*ones(size(X_test(y_test==y1,:),1),1);+1*ones(size(X_test(y_test==y2,:),1),1)];
X_fil_test_ext = [X_fil_TEST,ones(size(X_fil_TEST,1),1)];

condition_test = double((X_fil_test_ext*theta_f_best).*Y_fil_TEST>0);
ccr_fil_test = 1/length(X_fil_test_ext)*sum(condition_test);
disp("Testing CCR (filtered best): " + num2str(ccr_fil_test));

% end