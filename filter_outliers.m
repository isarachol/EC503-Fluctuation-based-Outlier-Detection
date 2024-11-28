%% filter outliers
function [X_filtered, y_filtered] = filter_outliers(X, y, index_outlier, Abnormal_number)
    n = length(y);
    Normal_index_0=index_outlier(1:n-Abnormal_number,:); %the rest is normal
    X_filtered = X(Normal_index_0,:);
    y_filtered = y(Normal_index_0,:);
end