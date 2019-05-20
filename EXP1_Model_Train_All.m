%Cohort 1: Train for CQ1- Prediction of DMI 
%Maximize Sensitivity
%Last Edit by Marelyn Rios June 27, 2018
 
clear all; close all; clc;
% Age and BMI are included as features
warning('off','all') % To supress warnings due to svmtrain and svmclassify
% First weed out all the rows with any zero values
load data_plus_finite_features.mat

% ft contains a table of all the features with column headers
FT = table2array(SAHS_features);
FT(:,11:18)=[]; FT(:,end)=[]; 
numFeatures = size(FT,2); % add one for label

FT=array2table(FT);
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
data_length = length(idx); %this will be subset length

%randomly select this many rows 
shuffle = randperm(data_length); %these are row indices 
idx = idx(shuffle,:); %rows have been shuffled 

% Extract features of DMI samples
data = FT{idx(1:160), :};
data_dmiHO = FT{idx(161:end), :}; %validation part 1 


% Extract the remaining Non-DMI samples
non_data = FT{:, :};
non_data(idx,:) = []; %deletes the dmi indices

%create validation set 
val_dmi = FT{idx(161:end), :}; %validation part 1 
shuffle_neg = randperm(length(non_data)); %shuffle 1302 
val_neg_class = non_data(shuffle_neg(1:77),:); %test ratio same as overall ratio
non_data(1:1,:) = []; %deletes val from non_data


% Randomly generate a dataset from non_data equal to the size of data
data_length = length(data);
non_data_length = length(non_data);
rand_idx = randperm (non_data_length , data_length);
rand_non_data = non_data(rand_idx,:);


% Split into 16 sets each of size 10
k = 10; %b/c 10 fold 
N = data_length/k;

% Include the labels too
pieces = reshape ( data', [numFeatures,N,k] );
non_pieces = reshape ( rand_non_data', [numFeatures,N,k] );

Data = [];
label = [];
% merge the two subsets (note data & label are currently 2 diff arrays)
for ii = 1 : k %for each fold 
    Data = vertcat (Data, pieces(:,:,ii)' , non_pieces(:,:,ii)');
    label = vertcat (label, ones(size(pieces(:,:,ii),2),1) , zeros(size(non_pieces(:,:,ii),2),1));
end


%combine validation set 
HO_labels = [ones(11,1);ones(77,1)*-1]; 
HO_Data = vertcat(val_dmi, val_neg_class);

% Create training and test sets for the data
% 34 samples in the test set (2N)
% 306 samples in the training set (k-1)*2N -- for 10 fold partition
idx_Set = [ones(2*N,1); zeros((k-1)*2*N,1)];

tic
for NbF = 1%:3% : 3 %Features Selected (60 in total) 
  features = combinator(numFeatures,NbF,'c');%combinator 
    
  for i = 1:size(features,1), % For all feature combinations (no repetition) 
    disp('----------------------------------------')
    [NbF length(features) i]    

    %data = [dataAll(:,i)]; % data = all the predictors renparm creates a subset of data controlling # of features        
    val_data = Data(:,features(i, :));
        
    % Use K-fold validation to construct model 
    for kk = 1 : k
      test = idx_Set;
      train = ~test;
      cp = classperf(label);
      svmStruct(kk) = svmtrain(val_data(train,:),label(train,:), 'autoscale', true, 'kernel_function', 'rbf' , 'showplot',false);
      classes = svmclassify(svmStruct(kk),val_data(find(test),:), 'showplot',false);
      % use each fold as test data
      models{kk} = classperf(cp,classes,find(test));    % Store model for each fold 
      %temp(kk) = models{kk}.LastCorrectRate;
      idx_Set = circshift(idx_Set, N*kk); %34*kk b/c 340 samples 
      
    end
%     idx = find(models(kk));
%     CP = models(idx); 
   
 end  
    M1(NbF).featureName = features; 
    M1(NbF).featureNumber = ft.Properties.VariableNames; %name of each predictor 
%     M1(NbF).NamesCombo = M1(NbF).featureNumber(M1(NbF).featureName)
    
    
    M1(NbF).model = models; 
    M1(NbF).test = HO_Data; 
    M1(NbF).labels = HO_labels; 

 
end
save M1_Train_All M1
toc

