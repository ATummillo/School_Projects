function [test_y] = DT_base_full(tr_x, tr_y, test_x, params)
%full decision tree
tree = fitctree(tr_x, tr_y);
test_y = predict(tree, test_x);
end

