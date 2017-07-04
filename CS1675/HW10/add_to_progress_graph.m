
%% graphs the progress of the mean train and test errors for iterative procedures
% arguments: 1. graph structure
%            2. step number
%            3. train error
%            4. test error
% returns: updated graph structure

function [pgraph] = add_to_progress_graph(pgraph, T, traine_base, teste_base, traine_bag, teste_bag, traine_boost, teste_boost)

pgraph.T=[pgraph.T T];
%Base
pgraph.train_base=[pgraph.train_base traine_base];
pgraph.test_base=[pgraph.test_base teste_base];
%Bag
pgraph.train_bag=[pgraph.train_bag traine_bag];
pgraph.test_bag=[pgraph.test_bag teste_bag];
%Boost
pgraph.train_boost=[pgraph.train_boost traine_boost];
pgraph.test_boost=[pgraph.test_boost teste_boost];
%Base plot
plot(pgraph.T,pgraph.train_base,'-g');
hold on;
plot(pgraph.T,pgraph.test_base,'--g');
%Bag plot
plot(pgraph.T,pgraph.train_bag,'-b');
plot(pgraph.T,pgraph.test_bag,'--b');
%Boost plot
plot(pgraph.T,pgraph.train_boost,'-r');
plot(pgraph.T,pgraph.test_boost,'--r');
xlabel('T');
ylabel('Error');
title('(Progress of Errors)') %title
legend('Traine Base','Teste Base','Traine Bag','Teste Bag','Traine Boost','Teste Boost') %label of the graph
pause(pgraph.pause);
hold off;
end

 