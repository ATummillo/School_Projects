load example.txt

num_rows = size(example,1);
curr_row = zeros(1,4);

prob_pos = 0.02;
prob_neg = 0.98;

p_fever1_pos = 0.9;
p_fever0_pos = 0.1;
p_fever1_neg = 0.6;
p_fever0_neg = 0.4;
prob_fever1 = (p_fever1_pos*prob_pos+p_fever1_neg*prob_neg);
prob_fever0 = (p_fever0_pos*prob_pos+p_fever0_neg*prob_neg);

p_paleness1_pos = 0.7;
p_paleness0_pos = 0.3;
p_paleness1_neg = 0.5;
p_paleness0_neg = 0.5;
prob_paleness1 = (p_paleness1_pos*prob_pos+p_paleness1_neg*prob_neg);
prob_paleness0 = (p_paleness0_pos*prob_pos+p_paleness0_neg*prob_neg);

p_cough1_pos = 0.9; 
p_cough0_pos = 0.1;
p_cough1_neg = 0.1;
p_cough0_neg = 0.9;
prob_cough1 = (p_cough1_pos*prob_pos+p_cough1_neg*prob_neg);
prob_cough0 = (p_cough0_pos*prob_pos+p_cough0_neg*prob_neg);

p_HWBcount1_pos = 0.8;
p_HWBcount0_pos = 0.2;
p_HWBcount1_neg = 0.5;
p_HWBcount0_neg = 0.5;
prob_HWBcount1 = (p_HWBcount1_pos*prob_pos+p_HWBcount1_neg*prob_neg);
prob_HWBcount0 = (p_HWBcount0_pos*prob_pos+p_HWBcount0_neg*prob_neg);

for i = 1:num_rows
    curr_row = example(i,:);
    denom = 1;
    numer = prob_pos;
    
    for k = 1:4
        switch(k)
            case 1
                switch(curr_row(k))
                    case 1
                        numer = numer*p_fever1_pos;
                        denom = denom*prob_fever1;
                    case 0
                        numer = numer*p_fever0_pos;
                        denom = denom*prob_fever0;
                    case -1
                end
            case 2
                switch(curr_row(k))
                    case 1
                        numer = numer*p_paleness1_pos;
                        denom = denom*prob_paleness1;
                    case 0
                        numer = numer*p_paleness0_pos;
                        denom = denom*prob_paleness0;
                    case -1
                end
            case 3
                switch(curr_row(k))
                    case 1
                        numer = numer*p_cough1_pos;
                        denom = denom*prob_cough1;
                    case 0
                        numer = numer*p_cough0_pos;
                        denom = denom*prob_cough0;
                    case -1
                end
            case 4
                switch(curr_row(k))
                    case 1
                        numer = numer*p_HWBcount1_pos;
                        denom = denom*prob_HWBcount1;
                    case 0
                        numer = numer*p_HWBcount0_pos;
                        denom = denom*prob_HWBcount0;
                    case -1
                end
        end
    end
    prob_given_symptoms = numer/denom
end