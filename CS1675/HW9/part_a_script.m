function [min_sum] = part_a_script(clustering_data)
%Runs 30 iterations from part a
min_sum = 0;
min_run = 0;
best_idx_a = [];
for i=1:30
    [idx,C,sumd] = kmeans(clustering_data,2);
    s = sum(sumd);
    if(min_sum == 0 || s < min_sum)
        min_sum = s;
        min_run = i;
        best_idx_a = idx;
    end
end
end

