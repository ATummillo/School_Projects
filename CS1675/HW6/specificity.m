function [spec] = specificity(conf_mat)
%takes confusion matrix and returns specificity

spec = conf_mat(2,2)/(conf_mat(2,2)+conf_mat(1,2));
end

