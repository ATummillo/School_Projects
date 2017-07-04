load Data.txt;
perm_data = randintrlv(Data, 15);
size_data = size(perm_data,1);
rand_ind = randperm(size_data,size_data);
train_data = [];
test_data = [];

for i = 1:size_data
    if mod(rand_ind(i),3) == 0
        test_data = [test_data; perm_data(i,:)];
    else
        train_data = [train_data; perm_data(i,:)];
    end
end

dlmwrite('train_data.txt', train_data);
dlmwrite('test_data.txt', test_data);
    