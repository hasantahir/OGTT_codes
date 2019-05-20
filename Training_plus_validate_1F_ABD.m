clear all

% This code stores Training results on the test data. Twenty iterations
% were done and each was stored in a separate MAT file. Ten features were
% used that are:
% 1. Area under the glucose curve 0-120
% 2. Slope of Glucose curve 120-0
% 3. Slope of Glucose curve 120-60
% 4. Ethnicity
% 5. Slope of Insulin curve 120-0
% 6. Slope of Glucose curve 60-0
% 7. Slope of Glucose curve 30-0
% 8. Slope of Glucose curve 60-30
% 9. Slope of Insulin curve 120-60
% 10. Slope of Insulin curve 60-0
% 11. Area under the glucose curve 30-120
% 12. Area under the glucose curve 60-120

% clearvars -except M_all
% First select the one with best sensitivity

% Record max. validation accuracies of the models obtained from the ones
% that gave us the maximum training accuracy. But here we record all the
% accuracies to be stored for plotting box plots.

for iter = 1 : 100
    
    matfile = sprintf('%s_%d','ABD_1F',iter);
    load(matfile, 'M_all')
    
    disp('----------------------------------------')
    [iter]
    
    M2 = M_all;
    % find the size of all models object
    
    numFeatures = size(M2,2);
    
    for NbF = 1 : numFeatures
        len = size(M2(NbF).pred_models,2);
        
        train_models = M2(NbF).pred_models;
        validation_models = M2(NbF).val_models;
        
        % for each feature, find the best model, specificity, sensitivity,
        % accuracy-wise
        for i = 1 : len
            
            trmodel = train_models(i).pred_model;
            SP_tr(i) = trmodel.Specificity;
            SN_tr(i) = trmodel.Sensitivity;
            ACC_tr(i) = trmodel.CorrectRate;
            
            valmodel = validation_models(i).val_model;
            SP_val(i) = valmodel.Specificity;
            SN_val(i) = valmodel.Sensitivity;
            ACC_val(i) = valmodel.CorrectRate; % CorrectRate averages over all k-folds
            features(i) = M2(NbF).featureName([i]);
        end
        
%         % find indices of maximum accuracy, sensitivity and specificities
%         
%         [acc_r, acc_c] = find(ACC_tr == (max(ACC_tr)));
%         
%         [accmax,I] = max(ACC_tr(:));
%         [accmax_r, accmax_c] = ind2sub(size(ACC_tr),I);
%         %
%         % [sp,I] = max(SP);
%         % [sp_r, sp_c] = ind2sub(size(SP),I);
%         %
%         % [sn,I] = max(SN);
%         % [sn_r, sn_c] = ind2sub(size(SN),I);
%         
%         [sp_r, sp_c] = find(SP_tr == max(max(SP_tr)));
%         % sp_r = unique(sp_r);
%         % sp_c = unique(sp_c);
%         
%         [spmax,I] = max(SP_tr(:));
%         [spmax_r, spmax_c] = ind2sub(size(SP_tr),I);
%         
%         [sn_r, sn_c] = find(SN_tr == max(max(SN_tr)));
%         % sn_r = unique(sn_r);
%         % sn_c = unique(sn_c);
%         
%         [snmax,I] = max(SN_tr(:));
%         [snmax_r, snmax_c] = ind2sub(size(SN_tr),I);
%         
%         % Confusion Matrix for the highest accuracy model
%         % Since we take the transpose, so order reversed
%         CP = train_models(accmax_c).pred_model;
%         CP = (CP(accmax_r));
%         tr_CM_acc = CP.CountingMatrix;
%         
%         CP = validation_models(accmax_c).val_model;
%         CP = (CP(accmax_r));
%         val_CM_acc = CP.CountingMatrix;
        
        
        % Features providing the highest accuracy
        %     accmax_c, accmax_r;
        
        feat = M2(NbF).featureNumber(1,:);
        features = M2(NbF).featureName([1:2]);
        
%         % Confusion Matrix for the highest sensitivity model
%         % Since we take the transpose, so order reversed
%         CP = train_models(snmax_c).pred_model;
%         CP = (CP(snmax_r));
%         tr_CM_sn = CP.CountingMatrix;
%         
%         CP = validation_models(snmax_c).val_model;
%         CP = (CP(snmax_r));
%         val_CM_sn = CP.CountingMatrix;
%         
%         
%         % Confusion Matrix for the highest accuracy model
%         % Since we take the transpose, so order reversed
%         CP = train_models(spmax_c).pred_model;
%         CP = (CP(spmax_r));
%         tr_CM_sp = CP.CountingMatrix;
%         
%         CP = validation_models(spmax_c).val_model;
%         CP = (CP(spmax_r));
%         val_CM_sp = CP.CountingMatrix;
        
        
%         %% Find respective accuracy and sensitivity for model with highest SP
%         
%         sp = max(SP_tr);
%         
%         % Accuracy for SP
%         
%         acc_sp = ACC_tr(sp_r, sp_c);
%         acc_sp = acc_sp(:);
%         max_acc_sp = max(max(acc_sp));
%         [i_r_acc_sp, i_c_acc_sp] = find(acc_sp == max_acc_sp);
%         
%         % Sensitivity for SP
%         sn_sp = SN_tr(sp_r, sp_c);
%         sn_sp = sn_sp(:);
%         max_sn_sp = max(max(sn_sp));
%         [i_r_sn_sp, i_c_sn_sp] = find(sn_sp == max_sn_sp);
%         
%         % Accuaracy and Sensitivity at maximum specificity
%         spmax;
%         tr_ACC_max_SP = ACC_tr(spmax_r, spmax_c);
%         tr_SN_max_SP = SN_tr(spmax_r, spmax_c);
%         
%         % Corresponsing validation performance for the model index with
%         % max. specificity
%         val_SP_max_SP = SP_val(spmax_r, spmax_c);
%         val_ACC_max_SP = ACC_val(spmax_r, spmax_c);
%         val_SN_max_SP = SN_val(spmax_r, spmax_c);
%         
%         %% Find respective specificity and sensitivity for model with highest ACC
%         
%         acc = max(ACC_tr);
%         
%         % Specificity for ACC
%         sp_acc = SP_tr(acc_r, acc_c);
%         sp_acc = sp_acc(:);
%         max_sp_acc = max(max(sp_acc));
%         [i_r_sp_acc, i_c_sp_acc] = find(sp_acc == max_sp_acc);
%         
%         
%         % Sensitivity for ACC
%         sn_acc = SN_tr(acc_r, acc_c);
%         sn_acc = sn_acc(:);
%         max_sn_acc = max(max(sn_acc));
%         [i_r_sn_acc, i_c_sn_acc] = find(sn_acc == max_sn_acc);
%         
%         % Sensitivity and Specificity at maximum accuracy
%         accmax;
%         tr_SP_max_ACC = SP_tr(accmax_r, accmax_c);
%         tr_SN_max_ACC = SN_tr(accmax_r, accmax_c);
% 
%         val_ACC_max_ACC = ACC_val(accmax_r, accmax_c);        
%         val_SP_max_ACC = SP_val(accmax_r, accmax_c);
%         val_SN_max_ACC = SN_val(accmax_r, accmax_c);        
%         %% Find respective specificity and accuracy for model with highest SN
%         
%         sn = max(SN_tr);
%         
%         % Specificity for SN
%         sp_sn = SP_tr(sn_r, sn_c);
%         sp_sn = sp_sn(:);
%         max_sp_sn = max(max(sp_sn));
%         [i_r_sp_sn, i_c_sp_sn] = find(sp_sn == max_sp_sn);
%         
%         % Accuracy for SN
%         acc_sn = ACC_tr(sn_r, sn_c);
%         acc_sn = acc_sn(:);
%         max_acc_sn = max(max(acc_sn));
%         [i_r_acc_sn, i_c_acc_sn] = find(acc_sn == max_acc_sn);
%         
%         
%         % Accuaracy and Specificity at maximum  Sensitivity
%         snmax;
%         tr_ACC_max_SN = ACC_tr(snmax_r, snmax_c);
%         tr_SP_max_SN = SP_tr(snmax_r, snmax_c);
%         
%         val_SN_max_SN = SN_val(accmax_r, accmax_c);                
%         val_ACC_max_SN = ACC_val(snmax_r, snmax_c);
%         val_SP_max_SN = SP_val(snmax_r, snmax_c);        
        
        TpV(iter).acc = ACC_val;
        TpV(iter).sp = SP_val;
        TpV(iter).sn = SN_val;
        TpV(iter).features = M2.featureName([1:10]);
 
        clearvars -except TpV iter M2 
        
    end
    
end


save TpV_1F_ABD TpV
