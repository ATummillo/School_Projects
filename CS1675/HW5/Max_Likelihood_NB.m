function [mu_1_1,sigma_1_1,mu_1_2,sigma_1_2,mu_0_1,sigma_0_1,mu_0_2,sigma_0_2,p1] = Max_Likelihood_NB()
%Returns means and stds for univariate gaussians

load classification_train.txt;
data = classification_train;

c0 = data(data(:,end) == 0,:);
c1 = data(data(:,end) == 1,:);

[mu_1_1, sigma_1_1] = normfit(c1(:,1));
[mu_1_2, sigma_1_2] = normfit(c1(:,2));
[mu_0_1, sigma_0_1] = normfit(c0(:,1));
[mu_0_2, sigma_0_2] = normfit(c0(:,2));
p1 = size(c1,1)/(size(c0,1)+size(c1,1));
end

