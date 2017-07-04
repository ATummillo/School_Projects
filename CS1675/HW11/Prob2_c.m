load train_data.txt;
load test_data.txt;

tr_x = train_data(:,1:end-1);
tr_y = train_data(:,end);
test_x = test_data(:,1:end-1);
test_y = test_data(:,end);

dim_ind = wrapper_function('[@log_regression, []]', train_data);

rest_train = train_data(:,dim_ind);
rest_test = test_data(:,dim_ind);

wrap_pred_y = log_regression(rest_train, tr_y, rest_test);
full_pred_y = log_regression(tr_x, tr_y, test_x);

wrap_mat = confusion_matrix(wrap_pred_y, test_y)
wrap_error = mean_misclass_error(wrap_pred_y, test_y)
full_mat = confusion_matrix(full_pred_y, test_y)
full_error = mean_misclass_error(full_pred_y, test_y)

