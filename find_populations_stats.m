clear all;clc;clf;close all;

% Generate rbox plots of ranked features

load data_plus_features_ranked.mat


% Categorize the initial data into four categories
% DMI   CVI  Category
%  0     0   -> 1
%  0     1   -> 2
%  1     0   -> 3
%  1     1   -> 4

% % Basic features
% Glucose = table2array(SAHS_features(:,4:7));
% Insulin = table2array(SAHS_features(:,8:11));
% BMI = table2array(SAHS_features(:,3));
% AGE = table2array(SAHS_features(:,1));


ETHN = ft.ETHN;
% The computed features are stored from 17-60 columns
labels = Labels;

% labels(labels==1) = 0; labels(labels==2) = 0; %negative class (Non DMI)
% labels(labels==3) = 1; labels(labels==4) = 1; %positive class (DMI)

% % Age and BMI distribution at baseline
% % Number of diabetics with BMI
% BMI_21h = length(find(BMI <= 21));
% BMI_22_30h = length(find(BMI >= 22 & BMI <= 30));
% BMI_31_40h = length(find(BMI >= 31 & BMI <= 40));
% BMI_41h = length(find(BMI>=41));
% 
% % Number of diabetics with age
% AGE_40h = length(find(AGE <= 40));
% AGE_40_50h = length(find(AGE >= 41 & AGE <= 50));
% AGE_51_60h = length(find(AGE>51 & AGE <= 60));
% AGE_61h = length(find(AGE>60));


% Number of diabetics with enthnicities
MA = find(ETHN == 1); %
NHW = find(ETHN == 2); %

% Find DMI samples
idx_dmi = find (labels == 3);

dmi_length = length(idx_dmi); %this will be subset length

% Number of diabetics with enthnicities
dmi_idx_MA = find(ETHN(idx_dmi) == 1); %
dmi_idx_NHW = find(ETHN(idx_dmi) == 2); %




% Find CVD samples
idx_cvd = find (labels == 2);

cvd_length = length(idx_cvd); %this will be subset length

% Number of healthy with enthnicities
cvd_idx_MA = find(ETHN(idx_cvd) == 1); %
cvd_idx_NHW = find(ETHN(idx_cvd) == 2); %


% Find healthy samples
idx_health = find (labels == 1);

healthy_length = length(idx_health); %this will be subset length

% Number of healthy with enthnicities
healthy_idx_MA = find(ETHN(idx_health) == 1); %
healthy_idx_NHW = find(ETHN(idx_health) == 2); %


% Find Both samples
idx_both = find (labels == 4);

both_length = length(idx_both); %this will be subset length

% Number of healthy with enthnicities
both_idx_MA = find(ETHN(idx_both) == 1); %
both_idx_NHW = find(ETHN(idx_both) == 2); %




% % Number of diabetics with BMI
% BMI_21 = length(find(BMI(idx_dmi) <= 21));
% BMI_22_30 = length(find(BMI(idx_dmi) >= 22 & BMI(idx_dmi) <= 30));
% BMI_31_40 = length(find(BMI(idx_dmi) >= 31 & BMI(idx_dmi) <= 40));
% BMI_41 = length(find(BMI(idx_dmi)>=41));
% 
% % Number of diabetics with age
% AGE_40 = length(find(AGE(idx_dmi) <= 40));
% AGE_40_50 = length(find(AGE(idx_dmi) >= 41 & AGE(idx_dmi) <= 50));
% AGE_51_60 = length(find(AGE(idx_dmi)>51 & AGE(idx_dmi) <= 60));
% AGE_61 = length(find(AGE(idx_dmi)>60));

%
disp('BMI <= 21')
% [iter NbF length(features) i]

