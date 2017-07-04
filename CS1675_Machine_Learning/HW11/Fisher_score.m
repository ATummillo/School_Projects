function [score] = Fisher_score(x,y)
%Calculates Fisher scores
data = [x y];
class_0 = data(data(:,end) == 0,:);
class_0 = class_0(:,1);
class_1 = data(data(:,end) == 1,:);
class_1 = class_1(:,1);

mean_0 = mean(class_0);
std_0 = std(class_0);
mean_1 = mean(class_1);
std_1 = std(class_1);

score = (mean_0 - mean_1)^2/(std_0^2 + std_1^2);

end

