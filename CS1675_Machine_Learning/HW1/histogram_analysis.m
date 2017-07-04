function [] = histogram_analysis(attribute_vector)
%Takes the data for an attribute (as a vector) and plots a histogram with
%20 bins

nbins = 20;
hist(attribute_vector, nbins);


end

