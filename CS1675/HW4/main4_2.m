load housing_train.txt;
load housing_test.txt;

train_weights = LR_solve(housing_train(:,1:13),housing_train(:,14));

train_predictions = LR_predict(housing_train(:,1:13), train_weights);
test_predictions = LR_predict(housing_test(:,1:13), train_weights);

train_error = immse(housing_train(:,14), train_predictions)
test_error = immse(housing_test(:,14), test_predictions)


