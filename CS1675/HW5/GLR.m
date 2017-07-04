function [weights] = GLR(input_data, K)
%Runs GLR on input data and returns weights

ones_col = ones(size(input_data,1),1);
input_data = horzcat(ones_col, input_data);
weights = ones(3, 1)';


for k = 1:K
    sum_error = 0;
    l_rate = 2/k;
    for i = 1:size(input_data, 1)
        x = input_data(i,1:3);
        y = input_data(i, 4);
        f = x*weights';
        
        error = x*(y-log_function(f));
        sum_error = sum_error + error;
        
    end 
    gradient = l_rate.*(sum_error);
    weights = weights + gradient;
end


end

