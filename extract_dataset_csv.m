% This function can be run here, no calling needed

function [Dataset_out, Labels_out] = extract_dataset_PNDB_csv(file_name, n_max, label_col, save_files)
    arguments
        file_name string = "PNDB.csv"
        n_max int32 = 1000
        label_col int8 = 8
        save_files logical = 1 % this is optional
    end
    %% cd
    dataset_directory = 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Datasets';
    cd(dataset_directory);
    %% read data
    raw_data=readtable(file_name); % table object
    [n, dim] = size(raw_data);
    if n>n_max % limit data to n_max points
        n=n_max;
    end
    Dataset = zeros(n, dim-1);
    Labels = raw_data{1:n,label_col};

    %% copy data and convert to numbers if necessary
    for c=1:dim
        if c ~= label_col
            if iscell(raw_data{:,c}) % if the column is text
                for r=1:n
                    % convert data to char and if it contains 'no', set it to 0
                    % otherwise 1
                    Dataset(r,c) = double(contains(lower(char(raw_data{r,c})), 'no')); 
                end
            else % if the column is number
                Dataset(:,c) = raw_data{1:n,c};
            end
        end
    end
    %% (OPTIONAL) save to .mat
    if ~isempty(save_files)
        save('PNDB.mat', "Dataset");
        save('PNDB_labels.mat', "Labels");
    end
end