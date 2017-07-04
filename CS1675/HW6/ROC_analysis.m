load pima_train_norm.txt;
load pima_test_norm.txt;
load pima_train.txt;
load pima_test.txt;

%%%%% Calculate log_scores
logr_x_train = pima_train_norm(:,1:(end-1));
logr_y_train = pima_train_norm(:,end);
logr_x_test = pima_test_norm(:,1:(end-1));
logr_y_test = pima_test_norm(:,end);
ones_col = ones(size(logr_x_test,1),1);
logr_x_test = horzcat(ones_col, logr_x_test);
logr_scores = zeros(size(logr_x_test,1),1);
logr_weights = Log_regression(logr_x_train, logr_y_train, 2000);

for i = 1:size(logr_x_test,1)
    x = logr_x_test(i,:);
    logr_scores(i) = sigmoid_fun(x*logr_weights);
end

%%%%% Calculate nb_scores
nb_scores = get_NB_scores(pima_test);

%%%%% Calculate svm_scores
[w, b] = svml(pima_train(:,1:end-1), pima_train(:,end), 1);
svm_scores = zeros(size(pima_test,1),1);

for i = 1:size(pima_test,1)
    x = pima_test(i,1:end-1);
    svm_scores(i) = x*w + b;
end


%%%%% ROC analysis
[Xlog,Ylog,Tlog,AUClog] = perfcurve(logr_y_test, logr_scores, 1);
[Xnb,Ynb,Tnb,AUCnb] = perfcurve(pima_test(:,end), nb_scores, 1);
[Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(pima_test(:,end), svm_scores, 1);

plot(Xlog,Ylog);
hold on
plot(Xnb,Ynb);
plot(Xsvm,Ysvm);
legend('Logistic Regression','Support Vector Machines','Naive Bayes','Location','Best');
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC Curves for Logistic Regression, SVM, and Naive Bayes Classification');
xlabel('False positive rate');
ylabel('True positive rate');
hold off;