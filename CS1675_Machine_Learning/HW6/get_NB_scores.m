function [scores_y] = get_NB_scores(input_data)
%Returns probabilities

main2_2;
scores_y = ones(size(input_data,1),1);


for i = 1:size(input_data,1)
    p_0 = 1;
    p_1 = 1;
    X = input_data(i,1:8);
    
    for k = 1:8
        switch(k)
            case 1
                p_0 = p_0*exppdf(X(k), exp_0_1_muhat);
                p_1 = p_1*exppdf(X(k), exp_1_1_muhat);
            
            case 2
                p_0 = p_0*normpdf(X(k), norm_0_2_mu, norm_0_2_sigma);
                p_1 = p_1*normpdf(X(k), norm_1_2_mu, norm_1_2_sigma);

            case 3
                p_0 = p_0*normpdf(X(k), norm_0_3_mu, norm_0_3_sigma);
                p_1 = p_1*normpdf(X(k), norm_1_3_mu, norm_1_3_sigma);

            case 4
                p_0 = p_0*normpdf(X(k), norm_0_4_mu, norm_0_4_sigma);
                p_1 = p_1*normpdf(X(k), norm_1_4_mu, norm_1_4_sigma);

            case 5
                p_0 = p_0*exppdf(X(k), exp_0_5_muhat);
                p_1 = p_1*exppdf(X(k), exp_1_5_muhat);

            case 6
                p_0 = p_0*normpdf(X(k), norm_0_6_mu, norm_0_6_sigma);
                p_1 = p_1*normpdf(X(k), norm_1_6_mu, norm_1_6_sigma);

            case 7
                p_0 = p_0*exppdf(X(k), exp_0_7_muhat);
                p_1 = p_1*exppdf(X(k), exp_1_7_muhat);

            case 8
                p_0 = p_0*exppdf(X(k), exp_0_8_muhat);
                p_1 = p_1*exppdf(X(k), exp_1_8_muhat);      
        end
    end
    p_0 = p_0 *(prior_c0);
    p_1 = p_1 *(prior_c1);
    
    %r_0 = p_0/(p_0+p_1);
    r_1 = p_1/(p_0+p_1);
    
    scores_y(i) = r_1;
    %if r_0 > r_1
    %    disp(r_0);
    %else
    %    disp(r_1);
    %end
end
end

