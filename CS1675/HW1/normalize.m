function [normalized_vector] = normalize(input_vector)
%Takes an unnormalized vector of attribute values and returns the vector of
%values normlized according to the data mean and standard deviation

mean_vec = mean(input_vector);
std_vec = std(input_vector);

normalized_vector = ((input_vector - mean_vec)/std_vec);


end

