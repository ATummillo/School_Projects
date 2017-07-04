function [error] = mean_misclass(conf_mat)
%Calculates mean square misclassification error from a confusion matrix

tp = conf_mat(1,1);
fp = conf_mat(1,2);
fn = conf_mat(2,1);
tn = conf_mat(2,2);

error = (fp+fn)/(tp+fp+fn+tn);


end

