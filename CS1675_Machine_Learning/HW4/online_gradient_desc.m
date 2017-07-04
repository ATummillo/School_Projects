function [weights] = online_gradient_desc(input_data)
%Online gradient descent procedure
x_data = input_data;
column_ones = ones(size(input_data,1),1);
x_data(:,size(x_data,2)) = [];  %remove y values from data
x_data = horzcat(column_ones, x_data);  %add column of ones to x_data
y_data = input_data(:,size(input_data,2));

weights = zeros(size(input_data,2),1);
data_length = size(input_data, 1);

for i = 1:1000
    index = mod(i,data_length);
    
    if(index == 0)
        index = data_length;
    end
    
    x = x_data(index,:);
    y = y_data(index);
    learning_rate = (2/i);
    f = y - (x*weights);
    error = f*x;
    weights = weights + (learning_rate * error)';
    


end

