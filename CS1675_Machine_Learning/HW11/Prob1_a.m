load Data.txt
y_input = Data(:,end);
fisher_scores = zeros(70,1);

for i = 1:70
    %Seperate columns of x data and find fisher score
    x_data = Data(:,i);
    fisher_scores(i) = Fisher_score(x_data, y_input);
end

[sorted_scores, index] = sort(fisher_scores, 'descend');

for i = 1:20
    fprintf('Dimension #%d   Fisher score: %d\n', index(i), sorted_scores(i));
end