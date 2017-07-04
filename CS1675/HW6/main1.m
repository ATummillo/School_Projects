normalize_data;

num_columns = size(pima_train_norm,2);
x_train = pima_train_norm(:,1:(num_columns-1));
y_train = pima_train_norm(:,num_columns);

x_test = pima_test_norm(:,1:(num_columns-1));
y_test = pima_test_norm(:,num_columns);

%weights = Log_regression(x, y, 2000);
%weights = ones(num_columns,1);

pgraph = init_progress_graph();

for i = 1:2000
    
    if(mod(i,50) == 0)
        weights = Log_regression(x_train, y_train, i);
        
        train_pred = get_class(pima_train_norm, weights);
        test_pred = get_class(pima_test_norm, weights);
        
        train_error = mean_misclass_error(train_pred, y_train);
        test_error = mean_misclass_error(test_pred, y_test);
        
        pgraph = add_to_progress_graph(pgraph, i, train_error, test_error);
        
    end
end

train_matrix = confusion_matrix(train_pred, pima_train_norm(:,end));
test_matrix = confusion_matrix(test_pred, pima_test_norm(:,end));
        
sens = sensitivity(test_matrix);
spec = specificity(test_matrix);


        
        
        





