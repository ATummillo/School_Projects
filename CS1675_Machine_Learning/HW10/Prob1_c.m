load hw10_train.txt;
load hw10_test.txt;

tr_x = hw10_train(:,1:end-1);
tr_y = hw10_train(:,end);
test_x = hw10_test(:, 1:end-1);
real_test_y = hw10_test(:,end);
N_train = size(tr_x,1);
N_test = size(test_x,1);
pgraph = init_progress_graph;

%BASE
[train_y_base] = DT_base_simple(tr_x,tr_y,tr_x,[]);
[test_y_base] = DT_base_simple(tr_x,tr_y,test_x,[]);
train_error_base = sum(train_y_base ~= tr_y)/N_train;
test_error_base = sum(test_y_base ~= real_test_y)/N_test;
%display
disp('train_error_base:');
disp(num2str(train_error_base));
disp('test_error_base:');
disp(num2str(test_error_base));

for k = 2:10
    sum_train_error_bag = 0;
    sum_test_error_bag = 0;
    sum_train_error_boost = 0;
    sum_test_error_boost = 0;
    params = strcat('[@DT_base_simple,',num2str(k),',[]]');
    for i = 1:20
        %BAG
        [train_y_bag] = Bag_classifier(tr_x,tr_y,tr_x,params);
        [test_y_bag] = Bag_classifier(tr_x,tr_y,test_x,params);
            %Train
        train_error_bag = sum(train_y_bag ~= tr_y)/N_train;
        sum_train_error_bag = sum_train_error_bag + train_error_bag;
            %Test
        test_error_bag = sum(test_y_bag ~= real_test_y)/N_test;
        sum_test_error_bag = sum_test_error_bag + test_error_bag;
        %BOOST
        [train_y_boost] = Boost_classifier(tr_x,tr_y,tr_x,params);
        [test_y_boost] = Boost_classifier(tr_x,tr_y,test_x,params);
            %Train
        train_error_boost = sum(train_y_boost ~= tr_y)/N_train;
        sum_train_error_boost = sum_train_error_boost + train_error_boost;
            %Test
        test_error_boost = sum(test_y_boost ~= real_test_y)/N_test;
        sum_test_error_boost = sum_test_error_boost + test_error_boost;
    end
    avg_train_error_bag = sum_train_error_bag/20;
    avg_test_error_bag = sum_test_error_bag/20;
    avg_train_error_boost = sum_train_error_boost/20;
    avg_test_error_boost = sum_test_error_boost/20;
    %display
    disp(['avg_train_error_bag for T: ' num2str(k)]);
    disp(num2str(avg_train_error_bag));
    disp(['avg_test_error_bag for T: ' num2str(k)]);
    disp(num2str(avg_test_error_bag));
    disp(['avg_train_error_boost for T: ' num2str(k)]);
    disp(num2str(avg_train_error_boost));
    disp(['avg_test_error_boost for T: ' num2str(k)]);
    disp(num2str(avg_test_error_boost));
    %Update
    pgraph = add_to_progress_graph(pgraph, k, train_error_base, test_error_base, avg_train_error_bag, avg_test_error_bag, avg_train_error_boost, avg_test_error_boost);
end
