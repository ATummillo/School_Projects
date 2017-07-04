function [conf_mat] = confusion_matrix(data, w)
%Takes data and weights, returns confusion matrix

if(size(w,1) == 1)
    w = w';
end


conf_mat = zeros(2,2);
row_num = size(data,1);
ones_col = ones(row_num,1);
data = horzcat(ones_col, data);
col_num = size(data,2);

for i = 1:row_num
    x = data(i,1:(col_num-1));
    y = data(i, col_num);
    
    val = log_function(x*w);
    
    if(val >= 0.5)
        pred = 1;
    else
        pred = 0;
    end
    
    if(y == 1)
        if(pred == 1)
            conf_mat(1,1) = conf_mat(1,1) + 1;
        else
            conf_mat(2,1) = conf_mat(2,1) + 1;
        end
    else
        if(pred == 1)
            conf_mat(1,2) = conf_mat(1,2) + 1;
        else
            conf_mat(2,2) = conf_mat(2,2) + 1;
        end
    end
    

end

