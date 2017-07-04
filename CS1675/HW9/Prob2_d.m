%Needs Prob2_c.mat loaded to work properly
num_perms = 1000;
perm_scores = zeros(num_perms,1);

true_score = calc_agr(best_idx_a,class_labels);

for i=1:num_perms
    rand_labels = randintrlv(class_labels,i);
    perm_scores(i) = calc_agr(best_idx_a, rand_labels);
end

num_gteq = 0;
num_below = 0;

for k=1:num_perms
    if(perm_scores(k) < true_score)
        num_below = num_below + 1;
    else
        num_gteq = num_gteq + 1;
    end
end

hist(perm_scores)
