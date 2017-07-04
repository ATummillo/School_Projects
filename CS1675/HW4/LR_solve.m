function [w] = LR_solve(X, y)
one_col = ones(size(X,1),1);
X = horzcat(one_col,X);
w = X\y;
end

