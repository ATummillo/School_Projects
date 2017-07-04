function [normalized_data] = normalize(input_data, input_mean, input_std)
%Normalizes data using mean and std
normalized_data = [];

for i = 1:size(input_data,2)
    column = input_data(:,i);
    curr_mean = input_mean(i);
    curr_std = input_std(i);
    normalized_column = zeros(size(column,1),1);
    
    for k = 1:size(column,1)
        x = column(k);
        normalized_column(k) = (x-curr_mean)/curr_std;
    end
    normalized_data = [normalized_data normalized_column];
end


end

