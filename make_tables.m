clear all;clc;close all

load Validation_results_AbdulGhani_20 Validation_results

% Get the accuracies along with their features
%maximizing specificity 
numFeatures = size(Validation_results(1).max_acc,2);
numIterations = size(Validation_results,2);
for i = 1 : numFeatures
    for j = 1 : numIterations
        ACC(i,j) = Validation_results(j).acc_max_sp(i);
        SEN(i,j) = Validation_results(j).sn_max_sp(i);
        SP(i,j) = Validation_results(j).max_sp(i);
        Features{i,j} = Validation_results(j).features{i}; 
        CM_sp{i,j} = Validation_results(j).CM_sp{i};
    end
end


for ii = 1: numFeatures 
    AVG_ACC(ii) = mean(ACC(ii,:));
    AVG_SEN(ii) = mean(SEN(ii,:));
    AVG_SP(ii) = mean(SP(ii,:));
    
    MIN_ACC(ii) = min(ACC(ii,:));
    MIN_SEN(ii) = min(SEN(ii,:));
    MIN_SP(ii) = min(SP(ii,:));
    
    MAX_ACC(ii) = max(ACC(ii,:));
    MAX_SEN(ii) = max(SEN(ii,:));
    MAX_SP(ii) = max(SP(ii,:));
end 




