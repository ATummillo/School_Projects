load train_data.txt;
load Data.txt;

x_data = Data(:,1:end-1);
y_data = Data(:,end);
x_train = train_data(:,1:end-1);
y_train = train_data(:,end);

[coeff_train, scores_train, latent_train] = pca(x_train);
top_2 = [coeff_train(:,1) coeff_train(:,2)];

data_adjust = x_data;

for i = 1:70
    data_adjust(:,i) = data_adjust(:,i) - mean(x_data(:,i));
end

row_coeff = top_2';
row_data_adjust = data_adjust';
trans_data = [(row_coeff*row_data_adjust)' y_data];

trans_data_0 = trans_data(trans_data(:,end) == 0,:);
trans_data_1 = trans_data(trans_data(:,end) == 1,:);

scatter(trans_data_0(:,1),trans_data_0(:,2),[],[1 0 0]);
hold on;
scatter(trans_data_1(:,1),trans_data_1(:,2),[],[0 0 1]);