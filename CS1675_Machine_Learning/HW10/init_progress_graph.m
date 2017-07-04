%% graphs the progress of the mean train and test errors for iterative procedures
% initialization of the progress graph

function [pgraph] = init_progress_graph
pgraph.T=[];
pgraph.train_base=[];
pgraph.test_base=[];
pgraph.train_bag=[];
pgraph.test_bag=[];
pgraph.train_boost=[];
pgraph.test_boost=[];
pgraph.pause=1.5;
%% starts the new figure
figure;
end
