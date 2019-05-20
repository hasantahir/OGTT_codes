% 8-6-2018
% This code ranks the individual features using the feature selection algorithm
% MRMR. We select the five most significant features that give us the maximal statistical dependency
% The algoirthm is part of FEAST package and uses MRMR algorithm presented in:
% Feature Selection Based on Mutual Information: Criteria of Max-Dependency, Max-Relevance,
% and Min-Redundancy
% by Hanchuan Peng, Fuhui Long, and Chris Ding

clear all; close all; clc;

% Age, ETHNICITY and BMI are included as features
warning('off','all') % To supress warnings due to svmtrain and svmclassify

% First weed out all the rows with any zero values
% load data_plus_finite_features.mat
% load features_finite_features_eth.mat
load features_all


% ft contains a table of all the features with column headers
% SAHS_features(:,12:20) = [];
% SAHS_features(:,end) = [];

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
labels(labels==3) = -1; labels(labels==4) = 1; %positive class (DMI)

% Find DMI samples
idx = find (labels == 1);
% r = rem(length(idx),10); %calculates remainder
dmi_length = length(idx); %this will be subset length



% make 100 iterations for the randomized attempts
tic
for iter = 1 : 5
    
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
    ratio = 7.5;
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
    
    selectedFeatures = feast('mrmr',10,Data,label);
    
    Ranks(iter).featureNames = ft.Properties.VariableNames(selectedFeatures);
    Ranks(iter).featurelist = selectedFeatures;
    
end

matfile = sprintf('%s','feature_ranks');
save(matfile, 'Ranks')