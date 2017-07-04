function [training_set, testing_set] = divideset1(input_dataset, p_train)
%Split input_dataset into testing and training sets where the sizes will be
%inconsistent between runs of the function
    first_train = 1;
    first_test = 1;
    
    for i = 1:length(input_dataset)
        add_to_train = (rand <= p_train);
        
        if (add_to_train == 1)
            %Add the ith row from input_dataset to training_set
            if(first_train == 1)
                training_set = input_dataset(i,:);
                first_train = 0;
            else
                training_set = [training_set;input_dataset(i,:)];
            end
        else
            %Add the ith row from input_dataset to testing_set
            if(first_test == 1)
                testing_set = input_dataset(i,:);
                first_test = 0;
            else
                testing_set = [testing_set;input_dataset(i,:)];
            end
        end
    end          
end

