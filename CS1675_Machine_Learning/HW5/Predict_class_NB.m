function [pred_y] = Predict_class_NB(x_data,mu_1_1,sigma_1_1,mu_1_2,sigma_1_2,mu_0_1,sigma_0_1,mu_0_2,sigma_0_2,p1)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

num_rows = size(x_data,1);
pred_y = zeros(num_rows,1);

for i = 1:num_rows
    x = x_data(i,:);
    
    prob_0_1 = normpdf(x(1), mu_0_1, sigma_0_1);
    prob_0_2 = normpdf(x(2), mu_0_2, sigma_0_2);
    prob_1_1 = normpdf(x(1), mu_1_1, sigma_1_1);
    prob_1_2 = normpdf(x(2), mu_1_2, sigma_1_2);
    
    prob0 = prob_0_1*prob_0_2;
    prob1 = prob_1_1*prob_1_2;
    
    g0 = (prob0*(1-p1))/((prob0*(1-p1))+(prob1*(p1)));
    g1 = (prob1*(p1))/((prob0*(1-p1))+(prob1*(p1)));
    
    if g1 > g0
        pred_y(i) = 1;
    else
        pred_y(i) = 0;
    end
end
    
end

