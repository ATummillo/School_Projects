function [sens] = sensitivity(conf_mat)
%takes confusion matrix and returns senesitivity

sens = conf_mat(1,1)/(conf_mat(1,1)+conf_mat(2,1));
end

