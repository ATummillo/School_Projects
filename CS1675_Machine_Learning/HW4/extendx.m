function [expanded_x] = extendx(x)
num_columns = size(x,2);
expanded_x = x;

for i = 1:13
    for k = i:13
        expanded_x = [expanded_x (x(i)*x(k))];
    end
end

