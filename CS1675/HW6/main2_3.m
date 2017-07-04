load pima_train.txt;
load pima_test.txt;

pred_train = predict_NB(pima_train);
pred_test = predict_NB(pima_test);

train_error = mean_misclass_error(pred_train, pima_train(:,end));
test_error = mean_misclass_error(pred_test, pima_test(:,end));

conf_mat_train = confusion_matrix(pred_train, pima_train(:,end));
conf_mat_test = confusion_matrix(pred_test, pima_test(:,end));

sens = sensitivity(conf_mat_test);
spec = specificity(conf_mat_test);