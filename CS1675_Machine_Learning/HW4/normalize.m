function [normalized_data] = normalize(input_data, input_mean, input_std)
%Normalizes data using mean and std
num_cols = size(input_data,2);
num_rows = size(input_data,1);
normalized_data = zeros(num_rows, num_cols);

for i = 1:num_cols
    column = input_data(:,i);
    curr_mean = input_mean(i);
    curr_std = input_std(i);
    
    for k = 1:num_rows
        x = column(k);
        normalized_data(k,i) = (x-curr_mean)/curr_std;
    end
end
end

