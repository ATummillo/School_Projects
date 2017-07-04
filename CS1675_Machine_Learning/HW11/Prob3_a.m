load train_data.txt;
load Data.txt;

x_data = Data(:,1:end-1);
x_train = train_data(:,1:end-1);
[coeff_train, scores_train, latent_train] = pca(x_train);

for i = 1:10
    fprintf('Principal Component #%d   Eigenvalue:%d\n', i, latent_train(i));
end
