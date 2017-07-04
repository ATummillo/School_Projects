%Needs workspace Prob2_c loaded to work properly
num_match_c1 = 0;
num_mismatch_c1 = 0;
size_c1 = 0;

num_match_c2 = 0;
num_mismatch_c2 = 0;
size_c2 = 0;

row = [];

for i=1:180
    if(best_idx_a(i) == 1)
        if(class_labels(i) == 0)
            num_match_c1 = num_match_c1 + 1;
        else
            num_mismatch_c1 = num_mismatch_c1 + 1;
        end
        size_c1 = size_c1 + 1;
    else
        if(class_labels(i) == 1)
            num_match_c2 = num_match_c2 + 1;
        else
            num_mismatch_c2 = num_mismatch_c2 + 1;
        end
        size_c2 = size_c2 + 1;
    end
    
end