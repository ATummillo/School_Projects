function [input_indices] = wrapper_function(model, tr_data)
%Returns list of attributes that were selected for the model
%using the wrapper approach
[base_classifier, alg_params] = process_params(model);
data_size = size(tr_data, 1);
num_cols = size(tr_data(:,1:end-1),2);
internal_groups = crossvalind('Kfold', data_size, 3);
input_indices = [];
set1_ind = [];
set2_ind = [];
set3_ind = [];

for i = 1:data_size
    if internal_groups(i) == 1
        set1_ind = [set1_ind; i];
    elseif internal_groups(i) == 2
        set2_ind = [set2_ind; i];
    else
        set3_ind = [set3_ind; i];
    end
end

dataset1 = tr_data(set1_ind,:);
dataset2 = tr_data(set2_ind,:);
dataset3 = tr_data(set3_ind,:);
old_error = 1;

while(1)
    new_errors = [];
    for k = 1:num_cols
        %Don't try to re-add indices that are already accounted for
        if sum(ismember(input_indices, k)) == 1
            new_errors = [new_errors 1];
            continue;
        end
        
        ind_error = 0;
        sum_error = 0;
        for i = 1:3
            if i == 1
                internal_train = [dataset1; dataset2];
                internal_test = dataset3;
                internal_train_x = internal_train(:,1:end-1);
                internal_train_y = internal_train(:,end);
                internal_test_x = internal_test(:,1:end-1);
                internal_test_y = internal_test(:,end);
            elseif i == 2
                internal_train = [dataset1; dataset3];
                internal_test = dataset2;
                internal_train_x = internal_train(:,1:end-1);
                internal_train_y = internal_train(:,end);
                internal_test_x = internal_test(:,1:end-1);
                internal_test_y = internal_test(:,end);
            else
                internal_train = [dataset2; dataset3];
                internal_test = dataset1;
                internal_train_x = internal_train(:,1:end-1);
                internal_train_y = internal_train(:,end);
                internal_test_x = internal_test(:,1:end-1);
                internal_test_y = internal_test(:,end);
            end
            internal_train_x = internal_train_x(:,[input_indices k]);
            internal_test_x = internal_test_x(:,[input_indices k]);
            pred_y = feval(base_classifier, internal_train_x, internal_train_y, internal_test_x);
            ind_error = mean_misclass_error(pred_y, internal_test_y);
            sum_error = sum_error + ind_error;
        end
        mean_error = sum_error/3;
        new_errors = [new_errors mean_error];
    end
    [min_new_e, I] = min(new_errors);

    if(min_new_e < old_error)
        input_indices = [input_indices I];
        old_error = min_new_e;
    else
        break;
    end

end
end
