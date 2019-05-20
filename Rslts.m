% load M_train M_train
load 
% load Train_results Train_results

labels = M_train(NbF).labels;
Data = M_train(NbF).test; %Data

numFeatures = size(M_train(1).featureName,2);


for NbF = 1 :2
    
    
    modelStruct = M_train(NbF).svm_structs(Train_results.max_acc_idx_r(NbF));
    modelStruct = modelStruct.svmModel(Train_results.max_acc_idx_c(NbF));
    
    
    % cp = classperf(labels);
    features = combinator(numFeatures,NbF,'c');%combinator
    % classes = svmclassify(model,val_data, 'showplot',false);
    
    
    
    for i = 1:size(features,1) % For all feature combinations (no repetition)
        
        disp('----------------------------------------')
        [NbF length(features) i]
        
        val_data = Data(:,features(i, :));
        
        cp = classperf(labels);
        pred = svmclassify(modelStruct, val_data, 'Showplot',true);
        
        cp = classperf(cp, pred);
        p_model{i} = cp;
        
        xxx(i) = p_model{i}.LastCorrectRate;
        
%         cp.LastCorrectRate
        
    end
    
    idx = find (xxx == max(xxx));
    S(NbF) = (p_model{idx});
%     S(NbF).LastCorrectRate = p_model{idx}.LastCorrectRate;
%     S(NbF).Specificity = p_model{idx}.Specificity;
%     S(NbF).Sensitivity = p_model{idx}.Sensitivity;
    
end

