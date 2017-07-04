load pima.txt;

num_columns = size(pima,2);

c0 = pima(pima(:,num_columns) == 0, 1:(num_columns - 1));
c1 = pima(pima(:,num_columns) == 1, 1:(num_columns - 1));
prior_c0 = 339/539;
prior_c1 = 200/539;


for i = 1:8
    histogram_analysis(c0(:,i));
    figure;
    histogram_analysis(c1(:,i));
    
    if(i ~= 8) 
        figure;
    end
    
end
