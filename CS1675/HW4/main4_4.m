load housing_train.txt;
load housing_test.txt;

extended_train = [];
extended_test = [];

for i = 1:size(housing_train,1)
    extended_train = [extended_train; extendx(housing_train(i,1:13))];
end

for k = 1:size(housing_test,1)
    extended_test = [extended_test; extendx(housing_test(k,1:13))];
end

train_weights = LR_solve(extended_train,housing_train(:,14));

train_predictions = LR_predict(extended_train, train_weights);
test_predictions = LR_predict(extended_test, train_weights);

train_error = immse(housing_train(:,14), train_predictions)
test_error = immse(housing_test(:,14), test_predictions)


