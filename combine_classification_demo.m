% Combining features with labels (consider labels as another feature) when
% performing outlier detection, then filter out the outliers and perform
% SVM on unfiltered and filtered data to compare

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

%% Partition training and testing datasets at Random
train_ratio = 0.8; % 80% is for training
n_y0 = sum(int8(y==0));
n_y1 = sum(int8(y==1));
X_0 = X_combined(y==0, :);
X_1 = X_combined(y==1, :);
n_train_y0 = ceil(n_y0*train_ratio);
n_train_y1 = ceil(n_y1*train_ratio);
n_train = n_train_y0 + n_train_y1;
n_test = n-n_train;

index_y0 = randperm(n_y0);
index_y1 = randperm(n_y1);

X_combined_train = [X_0(index_y0(1:n_train_y0),:); X_1(index_y1(1:n_train_y1), :)];
X_train = X_combined_train(:,1:dim);
y_train = X_combined_train(:,end);

X_combined_test = [X_0(index_y0(n_train_y0+1:end),:); X_1(index_y1(n_train_y1+1:end), :)];
X_test = X_combined_test(:,1:dim);
y_test = X_combined_test(:,end);

fprintf("Method: Use labels as feature to find outliers");
fprintf("Performance on dataset " + dataset_name + num2str(dataset_num) + "\n");
fprintf("Using %d training data points and %d testing data points\n", ...
    n_train, n-(n_train));

%% Adding outliers to Training set
num_outliers = 200;
outlier_X = rand(num_outliers, 7) * 10; %- rand(num_outliers, 7) * 100; % [-100, 100]randomly generate
outlier_y = randi([0, 1], [num_outliers,1]); % label = 1 for outliers
X_train = [X_train; outlier_X];
y_train = [y_train; outlier_y];
X_combined_train = [X_train, y_train];
n_train_old = n_train;
n_train = n_train + num_outliers;
fprintf("Added " + num_outliers + " outliers to training dataset\n");

%% FBOD parameters
% hyper parameter
GraphNumber=10; % # of graphs
k=60; % # of neighbors
Abnormal_number_train=ceil(n_train*0.2); %abnormal number (how to select this number?)
Abnormal_number_test=ceil(n_test*0.2);
% ADLabels=y;
cd (graph_directory)
delete *.txt

%% FBOD and Filter training dataset
[value_outlier,index_outlier,OF] = FBOD(X_combined_train,GraphNumber,k, 'train_PNDB_');
threshold_correct = value_outlier(n_train_old);
[X_filtered, y_filtered, value_without_outlier, Abnormal_number] = filter_outliers(X_train, ...
    y_train, value_outlier, index_outlier, threshold_correct);

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
min_threshold = value_outlier(floor(n/2)); % mid way
CCR_best = CCR_train(end);
CCR_cross = [];
theta_f_best = theta;
Abnormal_number_best = 0;
for i=linspace(max_threshold, min_threshold, 30) % 30 validation points
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

fprintf("\nValidation: \nSVM on filtered dataset (from Dataset + Outliers)");
disp("Result for best OF threshold: " + num2str(best_threshold))
disp("CCR: " + num2str(CCR_best))
disp("Number of filtered data: " + num2str(Abnormal_number_best))

figure()
subplot(1,2,1)
plot(1:n_train, value_outlier)
title("Outlier Factors in Ascending Order #" + num2str(dataset_num));
xlabel("Data point (point 1 - point n)");
ylabel("Outlier factor");
subplot(1,2,2)
plot(linspace(max_threshold, min_threshold,  30), CCR_cross)
title("CCR as threshold decreases #" + num2str(dataset_num))
xlabel("threshold");
ylabel("CCR");

%% Testing
% Testing with theta from dataset with outliers
X_raw_TEST = [X_test(y_test==y1,:);X_test(y_test==y2,:)];
Y_raw_TEST = [-1*ones(size(X_test(y_test==y1,:),1),1);+1*ones(size(X_test(y_test==y2,:),1),1)];
X_raw_test_ext = [X_raw_TEST,ones(length(X_raw_TEST),1)];

fprintf("\nTesting: ");
fprintf("\n")
condition_test = double((X_raw_test_ext*theta).*Y_raw_TEST>0);
ccr_test = 1/size(X_raw_test_ext,1)*sum(condition_test);
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
ccr_fil_test = 1/size(X_fil_test_ext,1)*sum(condition_test);
disp("Testing CCR (filtered best): " + num2str(ccr_fil_test));

% end