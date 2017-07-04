function [traintest] = kfold_crossvalidation(data,k,m)
%data - the data being analyzed 
%k - the number of folds
%m - the test fold

data_length = length(data);
min_fold_length = data_length/k;
remainder = mod(data_length,k);
marker = data_length - remainder;
even_split = {1, k};
count = 1;

    while(count < marker)
        for i = 1:k
            temp = [];
            for j = 1:min_fold_length
                temp = [temp, data(count)];
                count = count + 1;
            end
            even_split{1, i} = temp;
        end
    end

    if(remainder > 0)
        start = marker + 1;
        cnt = 1;
        for index = start:data_length
            even_split{1,cnt} = [even_split{1,cnt}, data(index)];
            cnt = cnt + 1;
        end
    end
    
    traintest = {1,2};
    traintest{1,1} = [];
    traintest{1,2} = even_split{1,m};
    
    for last_index = 1:k
        if last_index ~= m
            traintest{1} = [traintest{1}, even_split{1,last_index}];
        end
    end
end

