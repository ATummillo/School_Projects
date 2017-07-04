function [discretized_vec] = discretize_attribute(input_vec, k)
%Takes a vector of attribute values, a number k (number of bins) and
%assigns each value to one of the k bins.

min_vec = min(input_vec);
max_vec = max(input_vec);
range_vec = range(input_vec);
edge_increment = (range_vec/k);

edges = min_vec:edge_increment:max_vec;

discretized_vec = discretize(input_vec, edges);


end

