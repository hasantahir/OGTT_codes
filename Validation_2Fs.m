%Validate the data Set
clear all; clc
%Last edit by Marelyn Rios on June 26,2018
tic
warning off
% load data_plus_finite_features.mat;
load M4_Trained_Struct M4



for NbF = 1:2
    
    idx_Set = M4(NbF).labels;
    Data = M4(NbF).test; %Data
    
    for ii = 1 : size(M4(NbF).SVM_structures,2)
        modelStruct = M4(NbF).SVM_structures(ii).models;
        
        %svmStruct
        numFeatures = size(Data,2); % add one for label
        features = combinator(numFeatures,NbF,'c');%combinator
        
        val_data = Data(:,features(NbF, :));
        
        
        for jj = 1:size(modelStruct,2)
            
            model = modelStruct(jj);
            test = idx_Set;  %does not change
            disp('----------------------------------------')
            [NbF  ii jj]
            
            %label = model(ii).GroupNames; %labels of train data
            cp = classperf(idx_Set);
            %Names = C1(NbF).Names;
            %ftTable = array2table(Names);
            classes = svmclassify(model,val_data, 'showplot',false);
            % use classperf to pick best model
            %                 classperf(cp,classes, [1:length(test)])
            models{jj} = classperf(cp,classes);
        end
        
        % Take all the models
        Feat_mod(ii).models = models;
        

    end
%     M1(NbF).featureNumber = ft.Properties.VariableNames; %name of each predictor
    M1(NbF).models = Feat_mod;
    
end

M4_test = M1;
save M4_Tested_Models_1F M4_test

toc
