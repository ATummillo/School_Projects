load housing_train.txt
load housing_test.txt

train_means = zeros(14,1)';
test_means = zeros(14,1)';
train_stds = zeros(14,1)';
test_stds = zeros(14,1)';

for i=1:14
    column_train = housing_train(:,i);
    column_test = housing_test(:,i);
    
    train_means(i) =  mean(column_train);
    test_means(i) =  mean(column_test);
    train_stds(i) = std(column_train);
    test_stds(i) = std(column_test);
end

normalized_train = normalize(housing_train, train_means, train_stds);
normalized_test = normalize(housing_test, test_means, test_stds);

%Online Gradient Descent procedure for normalized_train

x_data = normalized_train;
column_ones = ones(size(normalized_train,1),1);
x_data(:,size(x_data,2)) = [];  %remove y values from data
x_data = horzcat(column_ones, x_data);  %add column of ones to x_data
y_data = normalized_train(:,size(normalized_train,2));

train_weights = zeros(size(normalized_train,2),1);
data_length = size(normalized_train, 1);

pgraph = init_progress_graph();

for i = 1:1000
    
    if(mod(i,50) == 0)
        train_predictions = LR_predict(normalized_train(:,1:13), train_weights);
        test_predictions = LR_predict(normalized_test(:,1:13), train_weights);
        train_error = immse(normalized_train(:,14), train_predictions);
        test_error = immse(normalized_test(:,14), test_predictions);
       
        pgraph = add_to_progress_graph(pgraph, i, train_error, test_error); 
    end
    
    index = mod(i,data_length);
    
    if(index == 0)
        index = data_length;
    end
    
    x = x_data(index,:);
    y = y_data(index);
    learning_rate = (2/i);
    f = y - (x*train_weights);
    error = f*x;
    train_weights = train_weights + (learning_rate * error)';
    
end




train_predictions = LR_predict(normalized_train(:,1:13), train_weights);
test_predictions = LR_predict(normalized_test(:,1:13), train_weights);

train_error = immse(normalized_train(:,14), train_predictions)
test_error = immse(normalized_test(:,14), test_predictions)



        