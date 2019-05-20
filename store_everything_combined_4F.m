% ====================================================================
% ====================================================================
% Train keeping the classifier ratio the same as in original dataset
% 1. In this code, we don't take equal number of dmi and non-dmi samples
% but rather go with the ratio present in the dataset.
% This was suggested by Madhav
 
% 2. We use only top ten ranked features generated by filter method MRMR

% The rest of the code does testing and validation on the holdout data

% 3. The script is run for 100 attempts to minimize any effects produced
% by random generation of data test and validate

% 4. Ensure that each iteration creates a non-overlapping random set of
% training and holdout dataset for both classes
% 8-9-2018
% Hasan Tahir Abbas

% This code uses external combinator function downloaded from Matlab File
% Exchange
% ====================================================================
% ====================================================================

% Store all the SVM structures to be used to test the Hold Out data

clear all; close all; clc;

% Age and BMI are included as features
warning('off','all') % To supress warnings due to svmtrain and svmclassify

% First weed out all the rows with any zero values
% load data_plus_finite_features.mat
% load features_finite_features_eth.mat
% load feature_AbdulGhani
% load data_plus_features_ranked
load data_plus_features_combined

% load data_plus_features_ranked_short

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
labels(labels==1) = 0; labels(labels==2) = 0; %negative class (Non DMI)
labels(labels==3) = 1; labels(labels==4) = 1; %positive class (DMI)

% Find DMI samples
idx = find (labels == 1);
% r = rem(length(idx),10); %calculates remainder
dmi_length = length(idx); %this will be subset length

% make 100 iterations for the randomized attempts
tic
for iter = 1 : 100
    
    %% Randomly select this many rows
    
    % This makes sure that we have a random set of test and train samples
    % in each iteration
    shuffle = randperm(dmi_length); %these are row indices
    idx = idx(shuffle,:); %rows have been shuffled
    
    % Make subsets of DMI dataset into training, Holdout
    % this somehow becomes the negative class during training
    DMI_train = FT{idx(1:160), :};
    DMI_test = FT{idx(161:end), :}; % this is used for validation
    
    
    %% Extract the remaining Non-DMI samples
    non_data = FT{:, :};
    non_data(idx,:) = []; %deletes the dmi indices
    

    
    
    % Randomly generate a dataset from non_data maintaining the population
    % ratio in the dataset
    data_length = length(DMI_train);
    non_data_length = length(non_data);
    ratio = 7.5; % updated ratio
    rand_idx = randperm (non_data_length , round(ratio*data_length));
    rand_non_data = non_data(rand_idx,:);
    
    non_data(rand_idx,:) = [];
    % Split into 16 sets each of size 10
    k = 10; %b/c 10 fold
    N_dmi = data_length/k;
    N_nodmi = round(data_length/k*ratio);
    
    % Include the labels too
    pieces = reshape ( DMI_train', [numFeatures,N_dmi,k] );
    non_pieces = reshape ( rand_non_data', [numFeatures,N_nodmi,k] );
    
    Data = [];
    label = [];
    % merge the two subsets (note data & label are currently 2 diff arrays)
    for ii = 1 : k %for each fold
        Data = vertcat (Data, pieces(:,:,ii)' , non_pieces(:,:,ii)');
        label = vertcat (label, ones(size(pieces(:,:,ii),2),1) , zeros(size(non_pieces(:,:,ii),2),1));
    end
    
    % Create validation set
    val_dmi = FT{idx(161:end), :}; %validation part 1
    health_idx = randperm (round(ratio*size(val_dmi,1)));
    Healthydata_test = non_data(health_idx,:); %test ratio same as overall ratio
    
    %combine validation set
    HO_labels = [ones(11,1);zeros(size(Healthydata_test,1),1)];
    HO_Data = vertcat(val_dmi, Healthydata_test);
    
    %% Train SVM for every combination of features
    for NbF = 2 : 4 % : 3 %Features Selected (60 in total)
        
        % numFeatures = 10;
        
        features = combinator(numFeatures,NbF,'c'); % combinator
        
        
        
        for i = 1:size(features,1) % For all feature combinations (no repetition)
            
            disp('----------------------------------------')
            [iter NbF length(features) i]
            
            %data = [dataAll(:,i)]; % data = all the predictors renparm creates a subset of data controlling # of features
            val_data = Data(:,features(i, :));
            ho_data = HO_Data(:,features(i, :));
            cvFolds = crossvalind('Kfold', label, k);   %# get indices of 10-fold CV
            cp = classperf(label);
            
            % Use K-fold validation to construct model
            
            for kk = 1 : k
                
                testIdx = (cvFolds == kk);                %# get indices of test instances
                trainIdx = ~testIdx;
                options = statset('maxIter',2150000);
                
                % RBF Kernel
                % The values are obtained after optimizing
                svmModel = svmtrain(val_data(trainIdx,:), label(trainIdx), ...
                    'Autoscale',true, 'Showplot',false,...
                    'Method','QP', ...
                    'BoxConstraint',300, ...
                    'Kernel_Function','rbf', ...
                    'RBF_Sigma',7.5,...
                    'options',options);
                
%                 % Linear Kernel
%                 svmModel = svmtrain(val_data(trainIdx,:), label(trainIdx), ...
%                     'Autoscale',true, 'Showplot',false, 'Method','QP', ...
%                     'Kernel_Function','linear',...
%                     'options',options);
                
                pred = svmclassify(svmModel, val_data(testIdx,:), 'Showplot',false);
                p_model = classperf(cp, pred, testIdx);
                
            end
            
            p_model.CountingMatrix
            % Perform validation on the HO data using the averaged CV model
            cp2 = classperf(HO_labels);
            val_pred = svmclassify(svmModel, ho_data, 'Showplot',false);
            v_model = classperf(cp2, val_pred);
            v_model.CountingMatrix
            
            svm_structs(i).svmModel =  svmModel;
            pred_model(i).pred_model = p_model;
            val_model(i).val_model = v_model;
            
            %         clear svmModel p_model v_model
            
        end
        
        M_all(NbF).featureNumber = features;
        M_all(NbF).featureName = ft.Properties.VariableNames; %name of each predictor
        M_all(NbF).svm_structs = svm_structs;
        M_all(NbF).pred_models = pred_model;
        M_all(NbF).val_models = val_model;
        M_all(NbF).test = HO_Data;
        M_all(NbF).labels = HO_labels;
        %
        clear features svm_structs pred_model val_model
    end
    
    matfile = sprintf('%s_%d','Combined_4F',iter);
%     matfile = sprintf('%s_%d','Ranked_short_unbalanced_models',iter);
    
    save(matfile, 'M_all','idx')
    
    clear M_all
    
end

toc