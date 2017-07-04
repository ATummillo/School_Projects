load Data.txt
y_input = Data(:,end);
AUROC_scores = zeros(70,1);

for i = 1:70
    %Seperate columns of x data and AUROC score
    x_data = Data(:,i);
    AUROC_scores(i) = AUROC_score(x_data, y_input);
end

[sorted_scores, index] = sort(AUROC_scores, 'descend');

for i = 1:20
    fprintf('Dimension #%d   Fisher score: %d\n', index(i), sorted_scores(i));
end