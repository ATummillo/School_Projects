load pima_train.txt;
load pima_test.txt;

pima_train_norm = normalize_2(pima_train);
pima_test_norm = normalize_2(pima_test);

dlmwrite('pima_train_norm.txt', pima_train_norm);
dlmwrite('pima_test_norm.txt', pima_test_norm);




