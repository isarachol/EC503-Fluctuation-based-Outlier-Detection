function dataset = extract_dataset_csv(file_name, n_max, save_file_name)
    arguments
        file_name string
        n_max int8
        save_file_name char = '' % this is optional
    end
    %% read data
    raw_data=readtable(file_name); % table object
    [n, dim] = size(raw_data);
    if n>n_max % limit data to n_max points
        n=n_max;
    end
    dataset = zeros(n, dim);

    %% copy data and convert to numbers if necessary
    for c=1:dim
        if iscell(raw_data{:,c}) % if the column is text
            for r=1:n
                % convert data to char and if it contains 'no', set it to 0
                % otherwise 1
                dataset(r,c) = double(contains(lower(char(raw_data{r,c})), 'no')); 
            end
        else % if the column is number
            dataset(:,c) = raw_data{1:n,c};
        end
    end
    %% (OPTIONAL) save to .mat
    if ~isempty(save_file_name)
        save(save_file_name, "dataset");
    end
end