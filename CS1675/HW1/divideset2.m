function [training_set, testing_set] = divideset2(input_dataset, p_train)
%Split input_dataset into testing and training sets where the sizes will be
%consistent between runs of the function
    if ((p_train == 0) || (p_train == 1))
        disp('0 and 1 are invalid values for p_train. Please try again.');
        training_set = 0;
        testing_set = 0;
    else
        input_length = length(input_dataset);
        train_length = ceil((input_length*p_train));
        test_length = (input_length - train_length);
        if (test_length == 0)
            disp('That p_train value is too close to 1 for the size of this dataset');
            training_set = 0;
            testing_set = 0;
        else
            random_indexes = randperm(input_length);
            train_indexes = random_indexes(1:train_length);
            test_indexes = random_indexes((train_length+1):input_length);
            
            training_set = input_dataset(train_indexes,:);
            testing_set = input_dataset(test_indexes,:);
        end
    end
end

