clear all; close all; clc;

% Age and BMI are included as features
warning('off','all') % To supress warnings due to svmtrain and svmclassify

% First weed out all the rows with any zero values
% load data_plus_features.mat
load features_finite_features_eth.mat
% ft contains a table of all the features with column headers

% Feature_set = sortrows(SAHS_features,'DMI','descend');
numFeatures = width(ft); % add one for label

% The computed features are stored from 17-60 columns
labels = Labels;


%%% Variable information

% Data -- table of all extracted and some raw features like age and BMI
% label  -- classifier ( 0 or 1)


% Make the labels into only two categories
labels(labels==1) = 0;
labels(labels==2) = 0;
labels(labels==3) = 1;
labels(labels==4) = 0;

% Find DMI samples
dmi_idx = find (labels == 1);
dmi_idx = dmi_idx (1:end-1); % remove one to get 160 samples


% Extract features of DMI samples
dmi_data = ft{dmi_idx, :};

% Extract the remaining Non-DMI samples
nondmi_data = ft{:, :};
nondmi_data(dmi_idx,:) = [];


% Randomly generate a dataset from nondmi_data equal to the size of
% dmi_data

dmi_data_length = length(dmi_data);
nondmi_data_length = length(nondmi_data);

rand_idx = randperm (nondmi_data_length , dmi_data_length);

rand_nondmi_data = nondmi_data (rand_idx,:);
% rand_nondmi_labels = nondmi_labels ( rand_idx);

% Split into 16 sets each of size 10
N = 16;
k = 10;

% Include the labels too

dmi_pieces = reshape ( dmi_data', [numFeatures,N,k] );
nondmi_pieces = reshape ( rand_nondmi_data', [numFeatures,N,k] );

Data = [];
label = [];

% Create sequenced data set and label vector
for i = 1 : k
    Data = vertcat (Data, dmi_pieces(:,:,i)' , nondmi_pieces(:,:,i)');
    label = vertcat (label, ones(size(dmi_pieces(:,:,i),2),1) , zeros(size(nondmi_pieces(:,:,i),2),1));
end

% Create training and test sets for the data
% 32 samples in the test set (2N)
% 288 samples in the training set (k-1)*2N -- for 10 fold partition
idx_Set = [ones(2*N,1); zeros((k-1)*2*N,1)];

results = [];

% Initialize a confusion matrix for each feature
cfMat = zeros(2,2,numFeatures);

for ii = 1 : 1
    
    % Create combinations of number of features to be used at a time
    feature_comb = combinator(int8(numFeatures), int8(ii), 'c');
    
    correct=[];
    incorrect=[];
    feature_correct=[];
    feature_incorrect=[];
    %     confusion = zeros(3,2);
    
    for jj = 1 : length (feature_comb)
        
        confusion = zeros(3,2);
        
        % Create a subset of data controlling number of features
        val_data = Data(:,feature_comb(jj, :));
        
        % K-fold validation
        for kk = 1 : k
            
            test = idx_Set;
            train = ~test;
            
            cp = classperf(label);
            
            
            svmStruct = svmtrain(val_data(train,:),label(train,:), 'autoscale', true,...
                'kernel_function', 'rbf' , 'showplot',false);
            classes = svmclassify(svmStruct,val_data(find(test),:),...
                'showplot',false);
            
            % use each fold as test data
            idx_Set = circshift(idx_Set, 32*kk);
            
            % Store model for each fold
            models{kk} = classperf(cp,classes,find(test));
            
            models{kk}.CountingMatrix
            % Confusion matrix for each feature
            confusion = confusion + models{kk}.CountingMatrix;
            
        end
        
        % Pick the best model of the k- models with highest correct rate
        for mm = 1 : length(models)
            
            temp(mm) = models{mm}.LastCorrectRate;
            
        end
        
        high_idx = find( temp == max(temp));
        CP = models{high_idx(1)};
        
        correct(jj) = CP.LastCorrectRate;
        incorrect(jj) = CP.LastErrorRate;
        
        results = vertcat(results, [ii, jj, CP.CorrectRate]);
        
        % Confusion matrices separate for all features
        % Discard the third row of confusion matrix
        confusion(3,:) = [];
        
        % Plot confusion matrices for all features
        %         figure(jj)
        %         plotConfMat(confusion,{'1','0'})
        
        cfMat(:,:,jj) = confusion;
        
        
        
    end
    
end
save ogtt_all_features_3features results cfMat
