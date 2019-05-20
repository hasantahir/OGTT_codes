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
    
    matfile1 = sprintf('%s_%d','Best_4F',iter);
    %     matfile1 = sprintf('%s_%d','Combined_sp_acc_fourF',iter);
    %     matfile1 = sprintf('%s_%d','Combined_sp_acc_fourF',iter);
    load(matfile1, 'M_all')
    M2 = M_all;
    M2(1) = [];
    M2(1) = [];
    %     M2(1) = [];
    
    disp('----------------------------------------')
    [iter]
    
    
    % find the size of all models object
    
    numFeatures = 1;%size(M2,2);
    
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
            %             features(i) = M2(NbF).featureName([i]);
        end
        
        
        % Features providing the highest accuracy
        
        feat = M2(NbF).featureNumber(1,:);
        features = M2(NbF).featureName;
        
        TpV(iter).tracc = ACC_tr;
        TpV(iter).trsp = SP_tr;
        TpV(iter).trsn = SN_tr;
        
        TpV(iter).acc = ACC_val;
        TpV(iter).sp = SP_val;
        TpV(iter).sn = SN_val;
        TpV(iter).features = M2.featureName;
        
        clearvars -except TpV iter M2
        
    end
    
end


save TpV_best4 TpV
