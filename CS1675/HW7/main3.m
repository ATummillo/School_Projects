load pima_train.txt;
load pima_test.txt;

norm_train = normalize_2(pima_train);
norm_test = normalize_2(pima_test);

X_train = norm_train(:,1:end-1); 
Y_train = norm_train(:,end);

X_test = norm_test(:,1:end-1);
Y_test = norm_test(:,end);

num_rows = size(Y_test,1);
pred_y = zeros(num_rows, 1);


for i = 1:num_rows
    pred_y(i) = soft_nn(X_train, Y_train, X_test(i,:), 50);
end


error = sum(abs(pred_y-Y_test))/num_rows
accuracy = 1-error