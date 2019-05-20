% 1-10-2019
% This code ranks the individual features using the feature selection algorithm
% MRMR. We select the ten most significant features that give us the maximal statistical dependency
% The algoirthm is part of FEAST package and uses MRMR algorithm presented in:
% Feature Selection Based on Mutual Information: Criteria of Max-Dependency, Max-Relevance,
% and Min-Redundancy
% by Hanchuan Peng, Fuhui Long, and Chris Ding

% For both CVD and DMI

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

% Create the data
Data = FT{:, :};
selectedFeatures = feast('mrmr',10,Data,labels);

matfile = sprintf('%s','feature_ranks');
save(matfile, 'Ranks')