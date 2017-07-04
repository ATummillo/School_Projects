function [conf_mat] = confusion_matrix(pred_y, y)
%Calculates confusion matrix

conf_mat = zeros(2,2);

for i = 1:size(y,1)
    if y(i) == 1
        if pred_y(i) == 1
            conf_mat(1,1) = conf_mat(1,1) + 1;
        else
            conf_mat(2,1) = conf_mat(2,1) + 1;
        end
    else
        if(pred_y(i) == 1)
            conf_mat(1,2) = conf_mat(1,2) + 1;
        else
            conf_mat(2,2) = conf_mat(2,2) + 1;
        end
    end



end

