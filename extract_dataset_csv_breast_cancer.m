% This function can be run here, no calling needed
% Not work yet!

function [Dataset_out, Labels_out] = extract_dataset_PNDB_csv(file_name, n_max, save_files)
    arguments
        file_name string = "PNDB.csv"
        n_max int32 = 1000
        save_files logical = 1 % this is optional
    end
    %% cd
    dataset_directory = 'C:\Users\tandi\OneDrive\Desktop\Classes\2024 Fall\EC 503 A1 B1(recite)\Project\Datasets\PNDB';
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
        for c=1:dim-1
            if iscell(raw_data{:,c}) % if the column is text
                for r=1:n_max
                    % convert data to char and if it contains 'no', set it to 0
                    % otherwise 1
                    Dataset(r,c) = double(contains(lower(char(raw_data{(i-1)*n_max+r,c})), 'no')); 
                end
            else % if the column is number
                disp(i)
                Dataset(:,c) = raw_data{(i-1)*n_max+1:i*n_max,c};
            end
        end
        Labels = raw_data{(i-1)*n_max+1:i*n_max,dim}; % last column is labels
        %% (OPTIONAL) save to .mat
        if ~isempty(save_files)
            save("PNDB" + num2str(i) + ".mat", "Dataset");
            save("PNDB" + num2str(i) + "_labels.mat", "Labels");
        end
    end
end