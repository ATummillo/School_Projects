function [pred_y] = Predict_class(x_data, mean_1, mean_0, cov_m, p1)
%Predicts ys using parameter estimates 
%data should have class column removed already

num_rows = size(x_data,1);
pred_y = zeros(num_rows,1);

for i = 1:num_rows
    x = x_data(i,:);
    
    prob1 = mvnpdf(x,mean_1,cov_m);
    prob0 = mvnpdf(x,mean_0,cov_m);
    
    g1 = (prob1*p1)/((prob0*(1-p1))+(prob1*p1));
    g0 = (prob0*(1-p1))/((prob0*(1-p1))+(prob1*p1));
    
    if g1 > g0
        pred_y(i) = 1;
    else
        pred_y(i) = 0;
    end
end
    
end

