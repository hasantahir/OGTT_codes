
% Train keeping the classifier ratio the same
% In this code, we don't take equal number of dmi and non-dmi samples but rather
% go with the ratio present in the dataset.
% This was suggested by Madhav
% 7-26-2018
% The rest of the code does testing and validation on the holdout data
% The script is run for 100 attempts to minimize any effects produced by random generation of data
% , test and validate

% Store all the SVM structures to be used to test the Hold Out data

clear all; close all; clc;

% Age and BMI are included as features
warning('off','all') % To supress warnings due to svmtrain and svmclassify

% First weed out all the rows with any zero values
% load data_plus_finite_features.mat
% load features_finite_features_eth.mat
load feature_AbdulGhani


% ft contains a table of all the features with column headers
SAHS_features(:,12:20) = [];
SAHS_features(:,end) = [];

FT = table2array(ft);
numFeatures = size(FT,2); % add one for label

FT = array2table(FT);
% The computed features are stored from 17-60 columns
labels = Labels;

%%% Variable information
% Data -- table of all extracted and some raw features like age and BMI
% label  -- classifier ( 0 or 1)
% Construct positive and negative class
labels(labels==1) = -1; labels(labels==2) = -1; %negative class (Non DMI)
labels(labels==3) = 1; labels(labels==4) = 1; %positive class (DMI)

% Find DMI samples
idx = find (labels == 1);
% r = rem(length(idx),10); %calculates remainder
dmi_length = length(idx); %this will be subset length



% make 100 iterations for the randomized attempts
tic
for iter = 1 : 1
    
    % Randomly select this many rows
    shuffle = randperm(dmi_length); %these are row indices
    idx = idx(shuffle,:); %rows have been shuffled
    
    % Make subsets of DMI dataset into training, Holdout
    PCdata_train = FT{idx(1:160), :};
    PCdata_test = FT{idx(161:end), :}; % this is used for validation
    
    
    % Extract the remaining Non-DMI samples
    non_data = FT{:, :};
    non_data(idx,:) = []; %deletes the dmi indices
    
    % Create validation set
    val_dmi = FT{idx(161:end), :}; %validation part 1
    shuffle_neg = randperm(length(non_data)); %shuffle 1302
    NCdata_test = non_data(shuffle_neg(1:88),:); %test ratio same as overall ratio
    non_data(1:1,:) = []; %deletes val from non_data
    
    
    % Randomly generate a dataset from non_data equal to the size of data
    data_length = length(PCdata_train);
    non_data_length = length(non_data);
    ratio = 8;
    rand_idx = randperm (non_data_length , ratio*data_length);
    rand_non_data = non_data(rand_idx,:);
    
    
    % Split into 16 sets each of size 10
    k = 10; %b/c 10 fold
    N_dmi = data_length/k;
    N_nodmi = data_length/k*ratio;
    
    % Include the labels too
    pieces = reshape ( PCdata_train', [numFeatures,N_dmi,k] );
    non_pieces = reshape ( rand_non_data', [numFeatures,N_nodmi,k] );
    
    Data = [];
    label = [];
    % merge the two subsets (note data & label are currently 2 diff arrays)
    for ii = 1 : k %for each fold
        Data = vertcat (Data, pieces(:,:,ii)' , non_pieces(:,:,ii)');
        label = vertcat (label, ones(size(pieces(:,:,ii),2),1) , zeros(size(non_pieces(:,:,ii),2),1));
    end
    
    
    %combine validation set
    HO_labels = [ones(11,1);ones(88,1)*(-1)];
    HO_Data = vertcat(val_dmi, NCdata_test);
    
    % Create training and test sets for the data
    % 34 samples in the test set (2N)
    % 306 samples in the training set (k-1)*2N -- for 10 fold partition
    %     idx_Set = [ones(2*N,1); zeros((k-1)*2*N,1)];
    
    for NbF = 1 : 1% : 3 %Features Selected (60 in total)
        
        % numFeatures = 17;
        %svmStruct
        features = combinator(numFeatures,NbF,'c');%combinator
        cvFolds = crossvalind('Kfold', label, k);   %# get indices of 10-fold CV
        %# init performance tracker
        
        
        for i = 1:1%size(features,1) % For all feature combinations (no repetition)
            
            disp('----------------------------------------')
            [iter NbF length(features) i]
            
            %data = [dataAll(:,i)]; % data = all the predictors renparm creates a subset of data controlling # of features
            val_data = Data(:,features(i, :));
            ho_data = HO_Data(:,features(i, :));
            cvFolds = crossvalind('Kfold', label, k);   %# get indices of 10-fold CV
            
            % Use K-fold validation to construct model
            
%             for kk = 1 : k
                
%                 testIdx = (cvFolds == kk);                %# get indices of test instances
%                 trainIdx = ~testIdx;
                cp = classperf(label);
                options = statset('maxIter',215000);
                
                sigma = optimizableVariable('sigma',[1e-2,1e2],'Transform','log');
                box = optimizableVariable('box',[1e-2,1e2],'Transform','log');
                
                c = cvpartition(1440,'KFold',10);
                %% Objective Function
                % This function handle computes the cross-validation loss at parameters
                % |[sigma,box]|. For details, see <docid:stats_ug.bsu1r2a-1>.
                %
                % |bayesopt| passes the variable |z| to the objective function as a one-row
                % table.
                
                %                 ,'KernelScale','auto'
                %                  minfn = @(z)kfoldLoss(fitcsvm(val_data, label,...
                %                     'KernelFunction','rbf','BoxConstraint',z.box,...
                %                     'KernelScale',z.sigma));
                minfn = @(z)kfoldLoss(fitcsvm(val_data, label,'CVPartition',c,...
                    'KernelFunction','rbf','BoxConstraint',z.box,...
                    'KernelScale',z.sigma));
                
                %% Optimize Classifier
                % Search for the best parameters |[sigma,box]| using |bayesopt|. For
                % reproducibility, choose the |'expected-improvement-plus'| acquisition
                % function. The default acquisition function depends on run time, and so
                % can give varying results.
                
                results = bayesopt(minfn,[sigma,box],'IsObjectiveDeterministic',true,...
                    'AcquisitionFunctionName','expected-improvement-plus',...
                    'MaxObjectiveEvaluations', 10);
                
                %%
                % Use the results to train a new, optimized SVM classifier.
                z(1) = results.XAtMinObjective.sigma;
                z(2) = results.XAtMinObjective.box;
                
                SVMModel = fitcsvm(val_data, label,'KernelFunction','rbf',...
                    'KernelScale',z(1),'BoxConstraint',z(2));
                
                
                %                 Mdl = fitcsvm(val_data, label,'OptimizeHyperparameters','auto',...
                %                     'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
                %                     'expected-improvement-plus'))
                
                % RBF Kernel
                %                 svmModel = svmtrain(val_data(trainIdx,:), label(trainIdx), ...
                %                     'Autoscale',true, 'Showplot',false, 'Method','QP', ...
                %                     'BoxConstraint',2e-1, 'Kernel_Function','l', 'RBF_Sigma',1,...
                %                     'options',options);
                
                % Linear Kernel
                %                 svmModel = svmtrain(val_data(trainIdx,:), label(trainIdx), ...
                %                     'Autoscale',true, 'Showplot',false, 'Method','QP', ...
                %                     'Kernel_Function','linear',...
                %                     'options',options);
                
                %                 pred = svmclassify(svmModel, val_data(testIdx,:), 'Showplot',false);
                %                 p_model = classperf(cp, pred, testIdx);
                
%             end
            
            
            % Perform validation on the HO data using the averaged CV model
            %             cp2 = classperf(HO_labels);
%             v = predict(SVMModel,val_ata)
            [w, score] = predict(SVMModel,ho_data)
            %             [label,score,node,cnum] = predict(SVMModel,ho_data)
            %             val_pred = svmclassify(svmModel, ho_data, 'Showplot',false);
            %             v_model = classperf(cp2, val_pred);
            
            %             svm_structs(i).svmModel =  svmModel;
            %             pred_model(i).pred_model = p_model;
            %             val_model(i).val_model = v_model;
            
            
            %         clear svmModel p_model v_model
            
        end
        
        M_all(NbF).featureNumber = features;
        M_all(NbF).featureName = ft.Properties.VariableNames; %name of each predictor
        %         M_all(NbF).svm_structs = svm_structs;
        %         M_all(NbF).pred_models = pred_model;
        %         M_all(NbF).val_models = val_model;
        M_all(NbF).test = HO_Data;
        M_all(NbF).labels = HO_labels;
        %
        clear features svm_structs pred_model val_model
    end
    
    %     matfile = sprintf('%s_%d','AbdulGhani_unbalanced_models',iter);
    %
    %     save(matfile, 'M_all')
    %
    %     clear M_all
end

tr_Data = (Data);
tr_label = (label);

Train = [tr_Data , tr_label];
HO_Data = (HO_Data);


toc
