function [pred_y] = predict_y(yhat)
%predict y values
size_y = size(yhat, 1);
pred_y = zeros(size_y,1);

    for i = 1:size_y
        if(yhat(i) >= 0.5)
            pred_y(i) = 1;
        end
    end
end

