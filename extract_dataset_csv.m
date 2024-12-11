% This function can be run here, no calling needed

% function [Dataset_out, Labels_out] = extract_dataset_breast_cancer_csv(file_name, n_max, save_files)
    % arguments
    file_name = "Breast_Cancer.csv";
    n_max = 1000;
    save_files = 1; % this is optional
    % end
    %% cd
    dataset_directory = 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Datasets\Breast_Cancer';
    cd(dataset_directory);
    %% read data
    raw_data=readtable(file_name); % table object
    [n, dim] = size(raw_data);
    if n>n_max % limit data to n_max points
        %n=n_max;
        iterations = floor(n/n_max);
    else
        n_max = n;
        iterations = 1;
    end

    Dataset = zeros(n_max, dim-1);

    for i=1:iterations
        %% copy data and convert to numbers if necessary
        for c=1:dim
            if iscell(raw_data{:,c}) % if the column is text
                if c == 2
                    keyword = ["White"; "Black"; "Other"];
                elseif c==3
                    keyword = ["Married"; "Single"; "Divorced"];
                elseif c==4
                    keyword = ["T1"; "T2"; "T3"; "T4"];
                elseif c==5
                    keyword = ["N1"; "N2"; "N3"];
                elseif c==6
                    keyword = ["IIA"; "IIIA"; "IIB"; "IIIB"; "IIC"; "IIIC"];
                elseif c==7
                    keyword = ["Poorly differentiated"; "Moderately differentiated"; "Well differentiated"];
                elseif c==9
                    keyword = ["Regional"; "Distant"];
                elseif c==12 || c==11
                    keyword = ["Positive"; "Negative"];
                elseif c==16
                    keyword = ["Alive"; "Dead"];
                end
                for r=1:n_max
                    % convert data to char and if it contains 'no', set it to 0
                    % otherwise 1
                    Dataset(r,c) = find(keyword == string(raw_data{(i-1)*n_max+r,c})); 
                end
            else % if the column is number
                disp(i)
                Dataset(:,c) = raw_data{(i-1)*n_max+1:i*n_max,c};
            end
        end
        % Labels = raw_data{(i-1)*n_max+1:i*n_max,dim}; % last column is labels
        %% (OPTIONAL) save to .mat
        if ~isempty(save_files)
            save("Breast_Cancer" + num2str(i) + ".mat", "Dataset");
            % save("Breast_Cancer" + num2str(i) + "_labels.mat", "Labels");
        end
    end
% end