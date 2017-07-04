function [mean_1, mean_0, cov_m, p1] = Max_Likelihood()
%Computes the estimates of the 
%model parameters using the training set

load classification_train.txt;

x_data = classification_train(:,1:end-1);

cov_m = cov(x_data);

data_1 = classification_train(classification_train(:,end) == 1, 1:end-1);
data_0 = classification_train(classification_train(:,end) == 0, 1:end-1);

mean_1 = mean(data_1);
mean_0 = mean(data_0);

p1 = (size(data_1,1)/size(classification_train,1));

end

