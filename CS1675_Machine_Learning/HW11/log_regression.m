function [test_y] = log_regression(tr_x, tr_y, test_x)
%Logistic regression classifier
Mdl = fitglm(tr_x, tr_y, 'Distribution', 'binomial');
test_y = predict_y(predict(Mdl, test_x));
end

