load pneumonia.tex;

pos = pneumonia (pneumonia(:,end) == 1,:);
num_pos = size(pos,1);
prob_pos = num_pos/size(pneumonia,1);
neg = pneumonia (pneumonia(:,end) == 0,:);
num_neg = size(neg,1);
prob_neg = num_neg/size(pneumonia,1);

pos_fever_1 = pos(pos(:,1) == 1,:);
pos_fever_0 = pos(pos(:,1) == 0,:);
neg_fever_1 = neg(neg(:,1) == 1,:);
neg_fever_0 = neg(neg(:,1) == 0,:);

pos_paleness_1 = pos(pos(:,2) == 1,:);
pos_paleness_0 = pos(pos(:,2) == 0,:);
neg_paleness_1 = neg(neg(:,2) == 1,:);
neg_paleness_0 = neg(neg(:,2) == 0,:);

pos_cough_1 = pos(pos(:,3) == 1,:);
pos_cough_0 = pos(pos(:,3) == 0,:);
neg_cough_1 = neg(neg(:,3) == 1,:);
neg_cough_0 = neg(neg(:,3) == 0,:);

pos_HWBcount_1 = pos(pos(:,4) == 1,:);
pos_HWBcount_0 = pos(pos(:,4) == 0,:);
neg_HWBcount_1 = neg(neg(:,4) == 1,:);
neg_HWBcount_0 = neg(neg(:,4) == 0,:);

p1fever_pos = size(pos_fever_1,1)/num_pos;
p0fever_pos = 1 - p1fever_pos;
p1fever_neg = size(neg_fever_1,1)/num_neg;
p0fever_neg = 1 - p1fever_neg;
prob_fever1 = (p1fever_pos*prob_pos+p1fever_neg*prob_neg);
prob_fever0 = (p0fever_pos*prob_pos+p0fever_neg*prob_neg);

p1paleness_pos = size(pos_paleness_1,1)/num_pos;
p0paleness_pos = 1 - p1paleness_pos;
p1paleness_neg = size(neg_paleness_1,1)/num_neg;
p0paleness_neg = 1 - p1paleness_neg;
prob_paleness1 = (p1paleness_pos*prob_pos+p1paleness_neg*prob_neg);
prob_paleness0 = (p0paleness_pos*prob_pos+p0paleness_neg*prob_neg);

p1cough_pos = size(pos_cough_1,1)/num_pos;
p0cough_pos = 1 - p1cough_pos;
p1cough_neg = size(neg_cough_1,1)/num_neg;
p0cough_neg = 1 - p1cough_neg;
prob_cough1 = (p1cough_pos*prob_pos+p1cough_neg*prob_neg);
prob_cough0 = (p0cough_pos*prob_pos+p0cough_neg*prob_neg);

p1HWBcount_pos = size(pos_HWBcount_1,1)/num_pos;
p0HWBcount_pos = 1 - p1HWBcount_pos;
p1HWBcount_neg = size(neg_HWBcount_1,1)/num_neg;
p0HWBcount_neg = 1 - p1HWBcount_neg;
prob_HWBcount1 = (p1HWBcount_pos*prob_pos+p1HWBcount_neg*prob_neg);
prob_HWBcount0 = (p0HWBcount_pos*prob_pos+p0HWBcount_neg*prob_neg);

numer1 = prob_pos*p1fever_pos*p0paleness_pos*p1cough_pos*p0HWBcount_pos;
denom1 = prob_fever1*prob_paleness0*prob_cough1*prob_HWBcount0;

answer1 = numer1/denom1

numer2 = prob_pos*p1fever_pos*p1cough_pos;
denom2 = prob_fever1*prob_cough1;

answer2 = numer2/denom2
