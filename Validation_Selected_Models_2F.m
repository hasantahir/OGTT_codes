clear all

load M4_Trained_Struct_2F_linear M4
load train_results Results

NbF = size(Results.max_acc,2);

R = Results;
M = M4;

for i = 1 : NbF
    
    idx_Set = M(i).labels;
    Data = M(i).test; %Data
    
    
    % Best acc model
    best_acc_model = M(i).SVM_structures(R.max_acc_idx_r(i)).models(R.max_acc_idx_c(i));
    
    % Best SP model
    best_sp_model = M(i).SVM_structures(R.max_sp_idx_r(i)).models(R.max_sp_idx_c(i));
    
    % Best SN model
    best_sn_model = M(i).SVM_structures(R.max_sn_idx_r(i)).models(R.max_sn_idx_c(i));
    
    models = {best_acc_model, best_sn_model, best_sp_model};
    %svmStruct
    
    for ii = 1 : size(M(i).SVM_structures,2)
        
        %svmStruct
        numFeatures = size(Data,2); % add one for label
        features = combinator(numFeatures,i,'c');%combinator
        
        val_data = Data(:,features(i, :));
        
        
        for jj = 1:size(models,2)
            
            model = models{jj};
            test = idx_Set;  %does not change
            disp('----------------------------------------')
            [i  ii jj]
            
            cp = classperf(idx_Set);
            classes = svmclassify(model,val_data, 'showplot',false);
            % use classperf to pick best model
            %                 classperf(cp,classes, [1:length(test)])
            mdl{jj} = classperf(cp,classes);
        end
        
        % Take all the models
        Feat_mod(ii).models = mdl;
        
        
    end
    
    M1(i).models = Feat_mod;
    
end

M4_test = M1;
save M4_Tested_Select_Models M4_test
