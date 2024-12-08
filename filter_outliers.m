%% filter outliers
function [X_filtered, y_filtered, value_without_outlier, Abnormal_number] = filter_outliers(X, y, value_outlier, index_outlier, threshold)
    n = length(y);
    % Normal_index_0 = index_outlier(1:n-Abnormal_number,:); %the rest is normal
    % X_filtered = X(Normal_index_0,:);
    % y_filtered = y(Normal_index_0,:);

    %% edited by Shuhao
    Normal_index_0 = [];
    Abnormal_number = 0;
    for i=n:-1:1
        if value_outlier(i) > threshold
            continue
        else
            Abnormal_number=n-i;
            break;
        end
    end
    if Abnormal_number == n
        Normal_index_0 = []; % No normal points
        value_without_outlier = [];
    else
        Normal_index_0 = index_outlier(1:(n - Abnormal_number));
        value_without_outlier = value_outlier(1:(n - Abnormal_number));
        % disp('Number of filtered data: '), disp(Abnormal_number),
    end

    X_filtered = X(Normal_index_0,:);
    y_filtered = y(Normal_index_0);
end
