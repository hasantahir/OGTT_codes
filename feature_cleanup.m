% further cleanup features
clear all
% load data_plus_features_0_120
% load data_plus_features_eth.mat
load features_all 
% load data_plus_features_AbdulGhani.mat
% load data_plus_features_AbdulGhani_short.mat
% load data_plus_features_ranked
% load data_plus_features_best_acc_sp
% load data_plus_features_combined
% load data_plus_features_best
% load data_plus_features_sofcare
% load data_plus_features_ranked_short
% load data_plus_features_best4


ft1 = table2array(ft);
[r1,c1] = find(ft1 == 0);
[r2,c2] = find(ft1 == inf);
[r3,c3] = find(isnan(ft1));



ft(r1,:) = [];
ft(r2,:) = [];
ft(r3,:) = [];

Labels(r1,:) = [];
Labels(r2,:) = [];
Labels(r3,:) = [];

SAHS_clean(r1,:) = [];
SAHS_clean(r2,:) = [];
SAHS_clean(r3,:) = [];

% SAHS_features(r1,:) = [];
% SAHS_features(r2,:) = [];
% SAHS_features(r3,:) = [];



% save features_finite_features_eth
save features_all 
% save  data_plus_features_eth.mat ft Labels SAHS_clean SAHS_features
% save data_plus_features_best4 SAHS_features SAHS_clean ft Labels
% save feature_AbdulGhani ft Labels SAHS_clean SAHS_features
% save data_plus_features_ranked ft Labels SAHS_clean SAHS_features
% save data_plus_features_best_acc_sp  ft Labels SAHS_clean SAHS_features
% load data_plus_features_combined ft Labels SAHS_clean SAHS_features
% load data_plus_features_best ft Labels SAHS_clean SAHS_features
% load data_plus_features_sofcare ft Labels SAHS_clean SAHS_features
% save data_plus_features_ranked_short ft Labels SAHS_clean SAHS_features
% save feature_AbdulGhani_short ft Labels SAHS_clean SAHS_features
