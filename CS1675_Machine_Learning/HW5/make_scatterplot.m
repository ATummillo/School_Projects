load classification_train.txt;
colors = ['r' 'b'];
shapes = ['o' 'x'];
y_outputs = classification_train(:,3);
vector1 = classification_train(:,1);
vector2 = classification_train(:,2);

gscatter(vector1, vector2, y_outputs, colors, shapes);