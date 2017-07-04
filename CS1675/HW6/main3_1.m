load pima_train.txt
load pima_test.txt

[w, b] = svml(pima_train(:,1:end-1), pima_train(:,end), 1);
train_pred = zeros(size(pima_train,1),1);
test_pred = zeros(size(pima_test,1),1);

for i = 1:size(pima_train,1)
    x = pima_train(i,1:end-1);
    val = x*w + b;
    if val > 0 
        train_pred(i) = 1;
    else
        train_pred(i) = 0;
    end
end

for i = 1:size(pima_test,1)
    x = pima_test(i,1:end-1);
    val = x*w + b;
    if val > 0 
        test_pred(i) = 1;
    else
        test_pred(i) = 0;
    end
end

train_error = mean_misclass_error(train_pred, pima_train(:,end));
test_error = mean_misclass_error(test_pred, pima_test(:,end));

conf_mat_train = confusion_matrix(train_pred, pima_train(:,end));
conf_mat_test = confusion_matrix(test_pred, pima_test(:,end));

    