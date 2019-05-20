clear all;close all;clc
load data_all

val_data = Data;
label = logical(label);

            for kk = 1 : k
                
                testIdx = (cvFolds == kk);                %# get indices of test instances
                trainIdx = ~testIdx;
            end

Mdl_svm1 = fitcsvm(val_data(trainIdx,:), label,...
    'Standardize',true, 'KernelScale',50000,...
    'BoxConstraint',.711, ...
    'KernelFunction','rbf', ...
    'Nu',.1,...
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
    val_data(:,1:3), label);

HO_labels = logical(HO_labels);
[labels,score] = predict(CompactSVMModel,HO_Data(:,1:3));

[Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(labels,score(:,1),'true');
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
% matlab2tikz('filename',sprintf('ROC_best.tex'));
% hgexport(gcf, 'ROC_best.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
% savefig('ROC_best.fig')
% print(gcf,'ROC_best.png','-dpng','-r900');
% 
% % 
% [labels,score] = predict(mdlSVM,HO_Data(:,1:3));


% 


% [labels,score] = predict(CompactSVMModel,HO_Data(:,1:3))
% 
% 
% 
% [Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(labels,score(:,2),'true');
% table(HO_labels,labels,score(:,1),'VariableNames',...
%     {'TrueLabels','PredictedLabels','PosClassPosterior'})
% 
% figure(2)
% 
% plot(Xsvm, Ysvm)
% plot(1 - score(:,1), score(:,2))
% AUCsvm