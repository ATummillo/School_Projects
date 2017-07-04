function [gaus] = gaussian_kernel(X, x, h)
%X is a row from the train data and x is the row we are comparing 
%it too, h is the smoothness parameter

ed_sq = sum((X-x).^2);
smooth = 2*h^2;
gaus = exp(-(ed_sq/smooth));

end

