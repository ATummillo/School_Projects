load pima_train.txt

c0 = pima_train(pima_train(:,end) == 0, 1:end - 1);
c1 = pima_train(pima_train(:,end) == 1, 1:end - 1);

prior_c0 = 339/539;
prior_c1 = 200/539;

%%%%%%

[exp_0_1_muhat, exp_0_1_muci] = expfit(c0(:,1));

[exp_1_1_muhat, exp_1_1_muci] = expfit(c1(:,1));

%%%%%%

[norm_0_2_mu,norm_0_2_sigma,muci_0_2,sci_0_2] = normfit(c0(:,2));

[norm_1_2_mu,norm_1_2_sigma,muci_1_2,sci_1_2] = normfit(c1(:,2));

%%%%%%

[norm_0_3_mu,norm_0_3_sigma,muci_0_3,sci_0_3] = normfit(c0(:,3));

[norm_1_3_mu,norm_1_3_sigma,muci_1_3,sci_1_3] = normfit(c1(:,3));

%%%%%%

[norm_0_4_mu,norm_0_4_sigma,muci_0_4,sci_0_4] = normfit(c0(:,4));

[norm_1_4_mu,norm_1_4_sigma,muci_1_4,sci_1_4] = normfit(c1(:,4));

%%%%%%

[exp_0_5_muhat, exp_0_5_muci] = expfit(c0(:,5));

[exp_1_5_muhat, exp_1_5_muci] = expfit(c1(:,5));

%%%%%%

[norm_0_6_mu,norm_0_6_sigma,muci_0_6,sci_0_6] = normfit(c0(:,6));

[norm_1_6_mu,norm_1_6_sigma,muci_1_6,sci_1_6] = normfit(c1(:,6));

%%%%%%

[exp_0_7_muhat, exp_0_7_muci] = expfit(c0(:,7));

[exp_1_7_muhat, exp_1_7_muci] = expfit(c1(:,7));

%%%%%%

[exp_0_8_muhat, exp_0_8_muci] = expfit(c0(:,8));

[exp_1_8_muhat, exp_1_8_muci] = expfit(c1(:,8));


