function [normalized_data] = normalize_2(input_data)
%Normalize data using mean and std

num_columns = size(input_data, 2);
y = input_data(:,num_columns);
normalized_data = [];

for i = 1:(num_columns-1)
    curr_vector = input_data(:,i);
    curr_mean = mean(curr_vector);
    curr_std = std(curr_vector);
    
    for k=1:size(curr_vector,1)
        curr_vector(k) = (curr_vector(k) - curr_mean)/(curr_std);
    end
    normalized_data = [normalized_data curr_vector];
    
end

normalized_data = [normalized_data y];


end

