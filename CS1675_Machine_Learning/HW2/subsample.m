function [newdata] = subsample(data, k)
%Randomly selects k instances from the data in the mean-study-data.txt
data_length = length(data);
rand_indexes = randperm(data_length, k);

newdata = data(rand_indexes,:);
end