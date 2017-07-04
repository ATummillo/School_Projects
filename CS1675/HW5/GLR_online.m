function [weights] = GLR_online(input_data, K)
%online gradient descent
ones_col = ones(size(input_data,1),1);
input_data = horzcat(ones_col, input_data);
weights = ones(3, 1)';
data_length = size(input_data, 1);

for k = 1:K

    index = mod(k,data_length);
    
        if(index == 0)
            index = data_length;
        end
    
    y = input_data(index, 4);
    x = input_data(index, 1:3);
    f = x*weights';
    l_rate = 0.01;
    gradient = l_rate*(y-log_function(f))*x;
    
    weights = weights + gradient;
end

