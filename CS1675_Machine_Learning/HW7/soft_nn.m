function [pred] = soft_nn(X, Y, x, h)

num_rows = size(X,1);
weights = zeros(num_rows,1);

for i = 1:num_rows
    weights(i) = gaussian_kernel(X(i,:),x,h);
end

Mdl = fitcknn(X, Y, 'NumNeighbors', num_rows, 'Weights', weights);
pred = predict(Mdl, x);


end

