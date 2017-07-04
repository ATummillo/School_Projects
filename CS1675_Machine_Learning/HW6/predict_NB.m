function [pred_Y] = predict_NB(input_data)
%takes input matrix X

main2_2;
pred_Y = ones(size(input_data,1),1);


for i = 1:size(input_data,1)
    sum_0 = 0;
    sum_1 = 0;
    X = input_data(i,1:8);
    
    for k = 1:8
        switch(k)
            case 1
                sum_0 = sum_0 + log(exppdf(X(k), exp_0_1_muhat));
                sum_1 = sum_1 + log(exppdf(X(k), exp_1_1_muhat));
            
            case 2
                sum_0 = sum_0 + log(normpdf(X(k), norm_0_2_mu, norm_0_2_sigma));
                sum_1 = sum_1 + log(normpdf(X(k), norm_1_2_mu, norm_1_2_sigma));

            case 3
                sum_0 = sum_0 + log(normpdf(X(k), norm_0_3_mu, norm_0_3_sigma));
                sum_1 = sum_1 + log(normpdf(X(k), norm_1_3_mu, norm_1_3_sigma));

            case 4
                sum_0 = sum_0 + log(normpdf(X(k), norm_0_4_mu, norm_0_4_sigma));
                sum_1 = sum_1 + log(normpdf(X(k), norm_1_4_mu, norm_1_4_sigma));

            case 5
                sum_0 = sum_0 + log(exppdf(X(k), exp_0_5_muhat));
                sum_1 = sum_1 + log(exppdf(X(k), exp_1_5_muhat));

            case 6
                sum_0 = sum_0 + log(normpdf(X(k), norm_0_6_mu, norm_0_6_sigma));
                sum_1 = sum_1 + log(normpdf(X(k), norm_1_6_mu, norm_1_6_sigma));

            case 7
                sum_0 = sum_0 + log(exppdf(X(k), exp_0_7_muhat));
                sum_1 = sum_1 + log(exppdf(X(k), exp_1_7_muhat));

            case 8
                sum_0 = sum_0 + log(exppdf(X(k), exp_0_8_muhat));
                sum_1 = sum_1 + log(exppdf(X(k), exp_1_8_muhat));      
        end
    end
    sum_0 = sum_0 + log(prior_c0);
    sum_1 = sum_1 + log(prior_c1);
    
    if sum_0 > sum_1
        pred_Y(i) = 0;
    else
        pred_Y(i) = 1;
    end
end

