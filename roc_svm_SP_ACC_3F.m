%%
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


% % Extract the remaining Non-DMI samples
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

%%
Mdl_svm1 = fitcsvm(val_data(:,[2,5,6]), label,...
    'Standardize',true, 'KernelScale',4.95,...
    'BoxConstraint',.711, ...
    'KernelFunction','rbf', ...
    'Solver','L1QP',...
    'IterationLimit',2150000);


CompactSVMModel = fitPosterior(Mdl_svm1,...
    val_data(:,[2,5,6]), label);

HO_labels = logical(HO_labels);
[labels,score] = predict(CompactSVMModel,HO_Data(:,[2,5,6]));

[Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(HO_labels,score(:,CompactSVMModel.ClassNames),'true');
table(HO_labels,labels,score(:,1),'VariableNames',...
    {'TrueLabels','PredictedLabels','PosClassPosterior'})



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
matlab2tikz('filename',sprintf('roc_sp_acc_3F.tex'));
hgexport(gcf, 'roc_sp_acc_3F.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('roc_sp_acc_3F.fig')
print(gcf,'roc_sp_acc_3F.png','-dpng','-r900');