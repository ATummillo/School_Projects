load train_data.txt;
load test_data.txt;

dim_ind_wrap = [29, 47, 12, 1, 70, 5];
dim_ind_auroc = [29, 48, 25, 21, 10, 19];

tr_x = train_data(:,1:end-1);
tr_y = train_data(:,end);
test_x = test_data(:,1:end-1);
test_y = test_data(:,end);

rest_train = train_data(:,dim_ind);
rest_test = test_data(:,dim_ind);
auroc_train = train_data(:, dim_ind_auroc);
auroc_test = test_data(:, dim_ind_auroc);

wrap_pred_y = log_regression(rest_train, tr_y, rest_test);
auroc_pred_y = log_regression(auroc_train, tr_y, auroc_test);

wrap_mat = confusion_matrix(wrap_pred_y, test_y)
wrap_error = mean_misclass_error(wrap_pred_y, test_y)
auroc_mat = confusion_matrix(auroc_pred_y, test_y)
auroc_error = mean_misclass_error(auroc_pred_y, test_y)