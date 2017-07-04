function [test_y] = DT_base_simple(tr_x, tr_y, test_x, params)
%simple decision tree
tree = fitctree(tr_x, tr_y, 'MaxNumSplits', 1);
test_y = predict(tree, test_x);
end

