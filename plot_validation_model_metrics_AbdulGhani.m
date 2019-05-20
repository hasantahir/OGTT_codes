clear all
% load M2_Train_2Fs.mat
% load M_train.mat
% load M_all_AbdulGhani


% clearvars -except M_all
% First select the one with best sensitivity

% load M_all_AbdulGhani11 M_all
% load M_all_AbdulGhani12 M_all
% load M_all_AbdulGhani13 M_all
% load M_all_AbdulGhani14 M_all
% load M_all_AbdulGhani15 M_all
% load M_all_AbdulGhani16 M_all
% load M_all_AbdulGhani17 M_all
% load M_all_AbdulGhani18 M_all
load M_all_AbdulGhani9 M_all
% load M_all_AbdulGhani20 M_all

M2 = M_all;
% find the size of all models object

numFeatures = size(M2,2);

for NbF = 1 : numFeatures
    len = size(M2(NbF).val_models,2);
    
    all_cv_models = M2(NbF).val_models;
    
    % for each feature, find the best model, specificity, sensitivity,
    % accuracy-wise
    for i = 1 : len
        
        model = all_cv_models(i).val_model;
        SP(i) = model.Specificity;
        SN(i) = model.Sensitivity;
        ACC(i) = model.LastCorrectRate;
    end
    
    % find indices of maximum accuracy, sensitivity and specificities
    
    [acc_r, acc_c] = find(ACC == (max(ACC)));
    
    [accmax,I] = max(ACC(:));
    [accmax_r, accmax_c] = ind2sub(size(ACC),I);
    %
    % [sp,I] = max(SP);
    % [sp_r, sp_c] = ind2sub(size(SP),I);
    %
    % [sn,I] = max(SN);
    % [sn_r, sn_c] = ind2sub(size(SN),I);
    
    [sp_r, sp_c] = find(SP == max(max(SP)));
    % sp_r = unique(sp_r);
    % sp_c = unique(sp_c);
    
    [spmax,I] = max(SP(:));
    [spmax_r, spmax_c] = ind2sub(size(SP),I);
    
    [sn_r, sn_c] = find(SN == max(max(SN)));
    % sn_r = unique(sn_r);
    % sn_c = unique(sn_c);
    
    [snmax,I] = max(SN(:));
    [snmax_r, snmax_c] = ind2sub(size(SN),I);
    
    % Confusion Matrix for the highest accuracy model
    % Since we take the transpose, so order reversed
    CP = all_cv_models(accmax_c).val_model;
    CP = (CP(accmax_r));
    CM_acc = CP.CountingMatrix;
    
    % Features providing the highest accuracy
%     accmax_c, accmax_r;
    feat = M2(NbF).featureNumber(accmax_c,:);
    features = M2(NbF).featureName([feat]);
    
    % Confusion Matrix for the highest sensitivity model
    % Since we take the transpose, so order reversed
    CP = all_cv_models(snmax_c).val_model;
    CP = (CP(snmax_r));
    CM_sn = CP.CountingMatrix;
    
    
    % Confusion Matrix for the highest accuracy model
    % Since we take the transpose, so order reversed
    CP = all_cv_models(spmax_c).val_model;
    CP = (CP(spmax_r));
    CM_sp = CP.CountingMatrix;
    
    
    %% Find respective accuracy and sensitivity for model with highest SP
    
    sp = max(SP);
    
    % Accuracy for SP
    
    acc_sp = ACC(sp_r, sp_c);
    acc_sp = acc_sp(:);
    max_acc_sp = max(max(acc_sp));
    [i_r_acc_sp, i_c_acc_sp] = find(acc_sp == max_acc_sp);
    
    % Sensitivity for SP
    sn_sp = SN(sp_r, sp_c);
    sn_sp = sn_sp(:);
    max_sn_sp = max(max(sn_sp));
    [i_r_sn_sp, i_c_sn_sp] = find(sn_sp == max_sn_sp);
    
    % Accuaracy and Sensitivity at maximum specificity
    spmax;
    ACC_max_SP = ACC(spmax_r, spmax_c);
    SN_max_SP = SN(spmax_r, spmax_c);
    
    %% Find respective specificity and sensitivity for model with highest ACC
    
    acc = max(ACC);
    
    % Specificity for ACC
    sp_acc = SP(acc_r, acc_c);
    sp_acc = sp_acc(:);
    max_sp_acc = max(max(sp_acc));
    [i_r_sp_acc, i_c_sp_acc] = find(sp_acc == max_sp_acc);
    
    
    % Sensitivity for ACC
    sn_acc = SN(acc_r, acc_c);
    sn_acc = sn_acc(:);
    max_sn_acc = max(max(sn_acc));
    [i_r_sn_acc, i_c_sn_acc] = find(sn_acc == max_sn_acc);
    
    % Sensitivity and Specificity at maximum accuracy
    accmax;
    SP_max_ACC = SP(accmax_r, accmax_c);
    SN_max_ACC = SN(accmax_r, accmax_c);
    
    %% Find respective specificity and accuracy for model with highest SN
    
    sn = max(SN);
    
    % Specificity for SN
    sp_sn = SP(sn_r, sn_c);
    sp_sn = sp_sn(:);
    max_sp_sn = max(max(sp_sn));
    [i_r_sp_sn, i_c_sp_sn] = find(sp_sn == max_sp_sn);
    
    % Accuracy for SN
    acc_sn = ACC(sn_r, sn_c);
    acc_sn = acc_sn(:);
    max_acc_sn = max(max(acc_sn));
    [i_r_acc_sn, i_c_acc_sn] = find(acc_sn == max_acc_sn);
    
    
    % Accuaracy and Specificity at maximum  Sensitivity
    snmax;
    ACC_max_SN = ACC(snmax_r, snmax_c);
    SP_max_SN = SP(snmax_r, snmax_c);
    
    
    Validation_results.max_acc(NbF) = accmax;
    Validation_results.max_acc_idx_r(NbF) = accmax_r;
    Validation_results.max_acc_idx_c(NbF) = accmax_c;
    Validation_results.sp_max_acc(NbF) = SP_max_ACC;
    Validation_results.sn_max_acc(NbF) = SN_max_ACC;
    
    Validation_results.max_sp(NbF) = spmax;
    Validation_results.max_sp_idx_r(NbF) = spmax_r;
    Validation_results.max_sp_idx_c(NbF) = spmax_c;
    Validation_results.acc_max_sp(NbF) = ACC_max_SP;
    Validation_results.sn_max_sp(NbF) = SN_max_SP;
    
    Validation_results.max_sn(NbF) = snmax;
    Validation_results.max_sn_idx_r(NbF) = snmax_r;
    Validation_results.max_sn_idx_c(NbF) = snmax_c;
    Validation_results.acc_max_sn(NbF) = ACC_max_SN;
    Validation_results.sp_max_sn(NbF) = SP_max_SN;
    
    Validation_results.CM_acc{NbF} = CM_acc;
    Validation_results.CM_sn{NbF} = CM_sn;
    Validation_results.CM_sp{NbF} = CM_sp;
    Validation_results.features{NbF} = features;
    clearvars -except M2 NbF numFeatures Validation_results
    
end


save Validation_results_AbdulGhani Validation_results
