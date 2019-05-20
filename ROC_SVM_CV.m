clear all;close all;clc
load data_all Data label HO_labels HO_Data

val_data = Data;
label = logical(label);
HO_labels = logical(HO_labels);
HO_Data = HO_Data;

% SVM Model
mdl_svm = fitcsvm(val_data, label,...
    'Standardize',true, 'KernelScale',50000,...
    'BoxConstraint',.711, ...
    'KernelFunction','rbf', ...
    'Nu',.1,...
    'Solver','L1QP',...
    'IterationLimit',2150000);

% Create a CV structure of the SVM model
cv_svm_mdl = crossval(mdl_svm);

% Perform loss estimation and fit post. probabilities
L = kfoldLoss(cv_svm_mdl); % k-fold loss in the CV
score_cv_svm_mdl = fitSVMPosterior(cv_svm_mdl); % fit postterioir probability
[~,dmi_porb] = kfoldPredict(score_cv_svm_mdl);  %positive class posterior probabilities

% Compute the ROC curve
[Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(label,...
    dmi_porb(:,cv_svm_mdl.ClassNames),1); % compute ROC curve


% Predict the labels from hold-out validation data
mdlSVM = fitPosterior(mdl_svm);
[~,score_svm] = resubPredict(mdlSVM);

[Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(label,...
    score_svm(:,mdlSVM.ClassNames),1);


% CompactSVMModel = compact(Mdl_svm1);
% [labels,score] = predict(CompactSVMModel,HO_Data);
% [Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(labels,score(:,1),'true');
% table(HO_labels,labels,score(:,1),'VariableNames',...
%     {'TrueLabels','PredictedLabels','PosClassPosterior'})


% Plot the ROC curve
figure(1)
plot(Xsvm,Ysvm,'LineWidth',1.2);
hold on


% legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('FPR','interpreter','latex'); % Add a legend

ylabel('TPR','interpreter','latex'); % Add a legend

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('ROC_best.tex'));
hgexport(gcf, 'ROC_best.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('ROC_best.fig')
print(gcf,'ROC_best.png','-dpng','-r900');

