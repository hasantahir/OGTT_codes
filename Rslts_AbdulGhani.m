% load M_train M_train
clear all
load M_train_AbdulGhani
load Train_results_AbdulGhani
% load Train_results Train_results

labels = M_train(1).labels;
Data = M_train(1).test; %Data

numFeatures = size(M_train,2);


for NbF = 1 : numFeatures
    
    
    modelStruct = M_train(NbF).svm_structs(Train_results.max_acc_idx_r(NbF));
    modelStruct = modelStruct.svmModel(Train_results.max_acc_idx_c(NbF));
    
    all_cv_models = M_train(NbF).pred_models;
    % cp = classperf(labels);
    features = combinator(numFeatures,NbF,'c');%combinator
    % classes = svmclassify(model,val_data, 'showplot',false);
    
    
    
    for i = 1:size(features,1) % For all feature combinations (no repetition)
        
        disp('----------------------------------------')
        [NbF length(features) i]
        
        val_data = Data(:,features(i, :));
        
        cp = classperf(labels);
        pred = svmclassify(modelStruct, val_data, 'Showplot',false);
        
        cp = classperf(cp, pred);
        p_model{i} = cp;
        
        ACC(i) = p_model{i}.LastCorrectRate;
        SN(i) = p_model{i}.Sensitivity;
        SP(i) = p_model{i}.Specificity;
        
        %         cp.LastCorrectRate
        
    end
    
    [acc_r, acc_c] = find(ACC == (max(ACC)));
    % acc_r = unique(acc_r); % use only unique indices
    % acc_c = unique(acc_c);
    
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
%     CP = all_cv_models(accmax_r).pred_model;
%     CP = cell2mat(CP(accmax_c));
%     CM = CP.CountingMatrix;
    
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
    spmax
    ACC_max_SP = ACC(spmax_r, spmax_c)
    SN_max_SP = SN(spmax_r, spmax_c)
    
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
    accmax
    SP_max_ACC = SP(accmax_r, accmax_c)
    SN_max_ACC = SN(accmax_r, accmax_c)
    
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
    snmax
    ACC_max_SN = ACC(snmax_r, snmax_c)
    SP_max_SN = SP(snmax_r, snmax_c)
    
    
%     CM,
    %     accmax, spmax, snmax
    % Store SP SN and ACC
    % ACC
    Val_results.max_acc(NbF) = accmax;
    Val_results.max_acc_idx_r(NbF) = accmax_r;
    Val_results.max_acc_idx_c(NbF) = accmax_c;
    Val_results.sp_max_acc(NbF) = SP_max_ACC;
    Val_results.sn_max_acc(NbF) = SN_max_ACC;
    
    Val_results.max_sp(NbF) = spmax;
    Val_results.max_sp_idx_r(NbF) = spmax_r;
    Val_results.max_sp_idx_c(NbF) = spmax_c;
    Val_results.acc_max_sp(NbF) = ACC_max_SP;
    Val_results.sn_max_sp(NbF) = SN_max_SP;
    
    Val_results.max_sn(NbF) = snmax;
    Val_results.max_sn_idx_r(NbF) = snmax_r;
    Val_results.max_sn_idx_c(NbF) = snmax_c;
    Val_results.acc_max_sn(NbF) = ACC_max_SN;
    Val_results.sp_max_sn(NbF) = SP_max_SN;
    
    Val_results.CM{NbF} = CM;
    
    %     S(NbF).LastCorrectRate = p_model{idx}.LastCorrectRate;
    %     S(NbF).Specificity = p_model{idx}.Specificity;
    %     S(NbF).Sensitivity = p_model{idx}.Sensitivity;
    
end

save Val_results_AbdulGhani Val_results
