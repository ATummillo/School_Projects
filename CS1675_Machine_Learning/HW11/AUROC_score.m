function [AUC] = AUROC_score(x,y)
%Calculates AUROC scores using logistic regression with
%logit function (canonical link function for binomial distribution)

pred_y = log_regression(x,y,x);

[X,Y,T,AUC] = perfcurve(y, pred_y, 1);
end

