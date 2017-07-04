load clustering_data.txt;

min_sum_a = part_a_script(clustering_data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_dist = max(pdist(clustering_data,'squaredeuclidean'));
target_dist = max_dist/2;
num_wins_a = 0;
num_wins_b = 0;
num_ties = 0;
for k=1:100
    min_sum_a = part_a_script(clustering_data);
    min_sum_b = 0;
    min_run = 0;
    for i=1:30
        c1 = 0;
        c2 = 0;

        while(pdist([c1;c2],'squaredeuclidean') < target_dist)
            c1 = clustering_data(randi(180),:);
            c2 = clustering_data(randi(180),:);
        end

        [idx,C,sumd] = kmeans(clustering_data,[],'Start',[c1;c2]);
        s = sum(sumd);
        if(min_sum_b == 0 || s < min_sum_b)
            min_sum_b = s;
            min_run = i;
        end

    end
    fprintf('Run #%d\n', k);
    
    if(min_sum_a < min_sum_b)
        %a wins
        fprintf('Initialization from part a.) performed better\n');
        fprintf('Minimum sum from part a.) implementation = %d\n', min_sum_a);
        num_wins_a = num_wins_a + 1;
    elseif(min_sum_b < min_sum_a)
        %b wins
        fprintf('Initialization from part b.) performed better\n');
        fprintf('Minimum sum from part b.) implementation = %d\n', min_sum_b);
        num_wins_b = num_wins_b + 1;
    else
        fprintf('There was a tie and neither performed better than the other');
        num_ties = num_ties + 1;
    end
end
fprintf('The initialization from part a.) performed better: %d times!\n', num_wins_a);
fprintf('The initialization from part b.) performed better: %d times!\n', num_wins_b);
fprintf('The initializations tied: %d times!\n', num_ties);