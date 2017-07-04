load train_data.txt;
load test_data.txt;
load Data.txt;

x_data = Data(:,1:end-1);
y_data = Data(:,end);
x_train = train_data(:,1:end-1);
y_train = train_data(:,end);
x_test = test_data(:,1:end-1);
y_test = test_data(:,end);

[coeff_train, scores_train, latent_train] = pca(x_train);
top_5 = [coeff_train(:,1) coeff_train(:,2) coeff_train(:,3) coeff_train(:,4) coeff_train(:,5) coeff_train(:,6) coeff_train(:,7) coeff_train(:,8) coeff_train(:,9) coeff_train(:,10)];

data_adjust = x_data;
train_adjust = x_train;
test_adjust = x_test;

for i = 1:70
    data_adjust(:,i) = data_adjust(:,i) - mean(x_data(:,i));
    train_adjust(:,i) = train_adjust(:,i) - mean(x_train(:,i));
    test_adjust(:,i) = test_adjust(:,i) - mean(x_test(:,i));
end

row_coeff = top_5';
row_data_adjust = data_adjust';
row_train_adjust = train_adjust';
row_test_adjust = test_adjust';

trans_data = (row_coeff*row_data_adjust)';
trans_train = (row_coeff*row_train_adjust)';
trans_test = (row_coeff*row_test_adjust)';

pred_y = log_regression(trans_train, y_train, trans_test);

conf_mat = confusion_matrix(pred_y, y_test)
test_error = mean_misclass_error(pred_y, y_test)