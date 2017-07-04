function [y] = LR_predict(X, w)
y = zeros(size(X,1),1);
one_col = ones(size(X,1),1);
X = horzcat(one_col,X);

for i = 1:size(X,1)
    for k = 1:length(X(1,:))
        y(i) = y(i) + (X(i,k)*w(k));
    end
end

end

