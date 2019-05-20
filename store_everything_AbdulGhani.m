%Cohort 1: Train for CQ1- Prediction of DMI



%Last Edit by Marelyn Rios June 27, 2018

% Store all the SVM structures to be used to test the Hold Out data

clear all; close all; clc;
% Age and BMI are included as features
warning('off','all') % To supress warnings due to svmtrain and svmclassify
% First weed out all the rows with any zero values
% load data_plus_finite_features.mat
% load features_finite_features_eth.mat
load feature_AbdulGhani


% ft contains a table of all the features with column headers
SAHS_features(:,12:20)=[];
SAHS_features(:,end)=[];

FT = table2array(ft);
numFeatures = size(FT,2); % add one for label

FT=array2table(FT);
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

for iter = 1 : 100
    
    % Randomly select this many rows
    shuffle = randperm(dmi_length); %these are row indices
    idx = idx(shuffle,:); %rows have been shuffled
    
    % Extract features of DMI samples
    PCdata_train = FT{idx(1:160), :};
    PCdata_test = FT{idx(161:end), :}; %validation part 1
    
    
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
    rand_idx = randperm (non_data_length , data_length);
    rand_non_data = non_data(rand_idx,:);
    
    
    % Split into 16 sets each of size 10
    k = 10; %b/c 10 fold
    N = data_length/k;
    
    % Include the labels too
    pieces = reshape ( PCdata_train', [numFeatures,N,k] );
    non_pieces = reshape ( rand_non_data', [numFeatures,N,k] );
    
    Data = [];
    label = [];
    % merge the two subsets (note data & label are currently 2 diff arrays)
    for ii = 1 : k %for each fold
        Data = vertcat (Data, pieces(:,:,ii)' , non_pieces(:,:,ii)');
        label = vertcat (label, ones(size(pieces(:,:,ii),2),1) , zeros(size(non_pieces(:,:,ii),2),1));
    end
    
    
    %combine validation set
    HO_labels = [ones(11,1);zeros(88,1)];
    HO_Data = vertcat(val_dmi, NCdata_test);
    
    % Create training and test sets for the data
    % 34 samples in the test set (2N)
    % 306 samples in the training set (k-1)*2N -- for 10 fold partition
    idx_Set = [ones(2*N,1); zeros((k-1)*2*N,1)];
    
    tic
    for NbF = 1 : numFeatures % : 3 %Features Selected (60 in total)
        
        % numFeatures = 17;
        %svmStruct
        features = combinator(numFeatures,NbF,'c');%combinator
        cvFolds = crossvalind('Kfold', label, k);   %# get indices of 10-fold CV
        %# init performance tracker
        
        
        for i = 1:size(features,1) % For all feature combinations (no repetition)
            
            disp('----------------------------------------')
            [iter NbF length(features) i]
            
            %data = [dataAll(:,i)]; % data = all the predictors renparm creates a subset of data controlling # of features
            val_data = Data(:,features(i, :));
            ho_data = HO_Data(:,features(i, :));
            cvFolds = crossvalind('Kfold', label, k);   %# get indices of 10-fold CV
            
            % Use K-fold validation to construct model
            
            for kk = 1 : k
                
                testIdx = (cvFolds == kk);                %# get indices of test instances
                trainIdx = ~testIdx;
                cp = classperf(label);
                options = statset('maxIter',215000);
                svmModel = svmtrain(val_data(trainIdx,:), label(trainIdx), ...
                    'Autoscale',true, 'Showplot',false, 'Method','QP', ...
                    'BoxConstraint',2e-1, 'Kernel_Function','rbf', 'RBF_Sigma',1,...
                    'options',options);
                pred = svmclassify(svmModel, val_data(testIdx,:), 'Showplot',false);
                p_model = classperf(cp, pred, testIdx);
                
            end
            
            % Perform validation on the HO data using the averaged CV model
            cp2 = classperf(HO_labels);
            val_pred = svmclassify(svmModel, ho_data, 'Showplot',false);
            v_model = classperf(cp2, val_pred);
            
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
    
    matfile = sprintf('%s_%d','AbdulGhani_models',iter);
    
    save(matfile, 'M_all')
    
    clear M_all
end

tr_Data = (Data);
tr_label = (label);

Train = [tr_Data , tr_label];
HO_Data = (HO_Data);


toc