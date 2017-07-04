function [agr_score] = calc_agr(idx_a,c_labels)
%Calculates agreement score
match_S1 = 0;
match_S2 = 0;
size_S1 = 0;
size_S2 = 0;

for i=1:180
    if(idx_a(i) == 1)  %%%%%Cluster S1%%%%%
        size_S1 = size_S1 + 1;
        if(c_labels(i) == 0)    %Label = 0
            match_S1 = match_S1 + 1;
        end
    else                %%%%%Cluster S2%%%%%
        size_S2 = size_S2 + 1;
        if(c_labels(i) == 0)    %Label = 0
            match_S2 = match_S2 + 1;
        end    
    end
end
%%%%%%%%%%%%%%%%%%
S1_0 = match_S1/size_S1;
S2_0 = match_S2/size_S2;

match_S1 = 0;
match_S2 = 0;

for i=1:180
    if(idx_a(i) == 1)  %%%%%Cluster S1%%%%%
        if(c_labels(i) == 1)
            match_S1 = match_S1 + 1;
        end
    else                %%%%%Cluster S2%%%%%
        if(c_labels(i) == 1)
            match_S2 = match_S2 + 1;
        end    
    end
end
%%%%%%%%%%%%%%%%%%
S1_1 = match_S1/size_S1;
S2_1 = match_S2/size_S2;

agr_S1_0_S2_0 = (S1_0+S2_0)/2;
agr_S1_0_S2_1 = (S1_0+S2_1)/2;
agr_S1_1_S2_0 = (S1_1+S2_0)/2;
agr_S1_1_S2_1 = (S1_1+S2_1)/2;
%%%%%%%%%%%%%%%%%%%%%%%%

agr_score = max([agr_S1_0_S2_0, agr_S1_0_S2_1, agr_S1_1_S2_0, agr_S1_1_S2_1]);
end

