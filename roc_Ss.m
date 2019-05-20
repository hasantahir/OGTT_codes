clear all;close all;clc
load data_all

val_data = Data;
label = logical(label);


Mdl_svm1 = fitcsvm(val_data(:,[1:3]), label,...
    'Standardize',true, 'KernelScale',3.07,...
    'BoxConstraint',0.711, ...
    'KernelFunction','rbf', ...
    'Solver','L1QP',...
    'IterationLimit',2150000);


CompactSVMModel = fitPosterior(Mdl_svm1,...
    val_data(:,[1:3]), label);

HO_labels = logical(HO_labels);
[labels,score] = predict(CompactSVMModel,HO_Data(:,[1:3]));

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
matlab2tikz('filename',sprintf('roc_sp_acc_ranked.tex'));
hgexport(gcf, 'roc_sp_acc_ranked.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('roc_sp_acc_ranked.fig')
print(gcf,'roc_sp_acc_ranked.png','-dpng','-r900');