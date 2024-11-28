function [value_outlier,index_outlier,OF, X_filtered, y_filtered] = FBOD(X,y,GraphNumber,k, prefix, Abnormal_number)
    GG_RandomLink(X,GraphNumber,k, prefix); % save txt files to \Graph
    [value_outlier,index_outlier,OF] = FVP(X',GraphNumber, prefix);

    %% filter outliers
    % n = length(y);
    % Normal_index_0=index_outlier(1:n-Abnormal_number,:); %the rest is normal
    % X_filtered = X(Normal_index_0,:);
    % y_filtered = y(Normal_index_0,:);
end