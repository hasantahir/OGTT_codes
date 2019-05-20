clear all;close all;clc
% load data_all

load data_plus_features_best_acc_sp

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

matfile1 = sprintf('%s_%d','Combined_sp_acc_4F',16);
load(matfile1, 'M_all', 'idx')

% make 100 iterations for the randomized attempts
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

% matfile1 = sprintf('%s_%d','Combined_sp_acc_4F',16);
% load(matfile1, 'M_all', 'idx')

val_data = Data;
label = logical(label);


Mdl_svm1 = fitcsvm(val_data(:,[2,5,6]), label,...
    'Standardize',true, 'KernelScale',1e-1,...
    'BoxConstraint',0.611, ...
    'KernelFunction','rbf', ...
    'Solver','L1QP',...
    'IterationLimit',2150000);
CompactSVMModel = compact(Mdl_svm1);

% Mdl_svm2 = fitcsvm(val_data(:,1:3), label,...
%     'Standardize',true, 'KernelScale',4.95,...
%     'BoxConstraint',.711, ...
%     'KernelFunction','rbf', ...
%     'Nu',.05,...
%     'Crossval','on',...
%     'IterationLimit',2150000);
%
% ScoreTransform = Mdl_svm2.ScoreTransform
% [ScoreCVSVMModel,ScoreParameters] = fitSVMPosterior(Mdl_svm2)


% Tuning
% rng default
% Mdl = fitcsvm(val_data(:,1:3),label,'OptimizeHyperparameters','auto',...
%     'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
%     'expected-improvement-plus'))

% CVSVMModel = fitcsvm(val_data, label,...
%                 'Standardize',true, 'KernelScale','auto',...
%                 'BoxConstraint',box_cons, ...
%                 'KernelFunction','rbf', ...
%                 'Nu',.1,...
%                 'CrossVal','on',...
%                 'IterationLimit',2150000);

% the best box-constraint values comes to ~.711 with a kernel scale of
% ~4.95



CompactSVMModel = fitPosterior(CompactSVMModel,...
    val_data(:,[2,5,6]), label);

HO_labels = logical(HO_labels);
[labels,score] = predict(CompactSVMModel,HO_Data(:,[2,5,6]));

[Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(HO_labels,score(:,2),'true');
table(HO_labels,labels,score(:,1),'VariableNames',...
    {'TrueLabels','PredictedLabels','PosClassPosterior'})


mdlSVM = fitPosterior(Mdl_svm1);
[~,score_svm] = resubPredict(mdlSVM);


[Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(label,...
    score_svm(:,mdlSVM.ClassNames),1);

figure(1)

AUCsvm
plot(Xsvm,Ysvm,'LineWidth',1.2,...
    'Color','black');

% legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('FPR','interpreter','latex'); % Add a legend

ylabel('TPR','interpreter','latex'); % Add a legend

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
% matlab2tikz('filename',sprintf('roc_sp_acc.tex'));
% hgexport(gcf, 'roc_sp_acc.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
% savefig('roc_sp_acc.fig')
% print(gcf,'roc_sp_acc.png','-dpng','-r900');


% [labels,score] = predict(mdlSVM,HO_Data(:,1:3))


%


% [labels,score] = predict(CompactSVMModel,HO_Data(:,1:3))
%
%
%
% [Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(labels,score(:,2),'true');
% table(HO_labels,labels,score(:,1),'VariableNames',...
%     {'TrueLabels','PredictedLabels','PosClassPosterior'})
% %
% figure(2)
%
% plot(Xsvm, Ysvm)
% plot(1 - score(:,1), score(:,2))
% AUCsvm