clear all;clc;close all;clf

load Training_plus_Validation_results_AbdulGhani_100iters Training_plus_Validation_results


% Get the accuracies along with their features
numFeatures = size(Training_plus_Validation_results(1).tr_max_acc,2);
numIterations = size(Training_plus_Validation_results,2);

for i = 1 : numFeatures
    
    for j = 1 : numIterations
        
        tr_SP(i,j) = Training_plus_Validation_results(j).tr_max_sp(i);
        tr_ACC(i,j) = Training_plus_Validation_results(j).tr_acc_max_sp(i);
        tr_SEN(i,j) = Training_plus_Validation_results(j).tr_sn_max_sp(i);
        tr_Features{i,j} = char((Training_plus_Validation_results(j).features{i}));
        
        val_SP(i,j) = Training_plus_Validation_results(j).val_sp_max_sp(i);
        val_ACC(i,j) = Training_plus_Validation_results(j).val_acc_max_sp(i);        
        val_SEN(i,j) = Training_plus_Validation_results(j).val_sn_max_sp(i);
        val_Features{i,j} = char((Training_plus_Validation_results(j).features{i}));
    end
end

%% Accuracy

mean_tr_ACC = mean(tr_ACC, 2);
max_tr_ACC = max(tr_ACC, [], 2);
min_tr_ACC = min(tr_ACC, [], 2);

mean_val_ACC = mean(val_ACC, 2);
max_val_ACC = max(val_ACC, [], 2);
min_val_ACC = min(val_ACC, [], 2);

%% Senstivity


mean_tr_SEN = mean(tr_SEN, 2);
max_tr_SEN = max(tr_SEN, [], 2);
min_tr_SEN = min(tr_SEN, [], 2);

mean_val_SEN = mean(val_SEN, 2);
max_val_SEN = max(val_SEN, [], 2);
min_val_SEN = min(val_SEN, [], 2);

%% Specificity

mean_tr_SP = mean(tr_SP, 2);
std_tr_SP = std(tr_SP,0, 2);
max_tr_SP = max(tr_SP, [], 2);
min_tr_SP = min(tr_SP, [], 2);

mean_val_SP = mean(val_SP, 2);
std_val_SP = std(val_SP,0, 2);
max_val_SP = max(val_SP, [], 2);
min_val_SP = min(val_SP, [], 2);



figure(1)
N = 3; % Number of colors to be used

% Use Brewer-map color scheme SET1

axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')

hold on

errorbar(1:10,(min_val_ACC+max_val_ACC)/2,(max_val_ACC-min_val_ACC)/2,...
    '-s','MarkerSize',.1,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue',...
    'LineStyle','none','Color', 'blue')

errorbar(1:10,(min_val_SEN+max_val_SEN)/2,(max_val_SEN-min_val_SEN)/2,...
    '-s','MarkerSize',.1,...
    'MarkerEdgeColor','red','MarkerFaceColor','red',...
    'LineStyle','none','Color', 'red')


errorbar(1:10,(min_val_SP+max_val_SP)/2,(max_val_SP-min_val_SP)/2,...
    '-s','MarkerSize',.1,...
    'MarkerEdgeColor','green','MarkerFaceColor','green',...
    'LineStyle','none','Color', 'green')

h1 = plot(1:10,mean_val_ACC, 's','MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor','blue',...
    'MarkerSize',9,...
    'LineWidth',0.5);

h2 = plot(1:10,mean_val_SEN, 's','MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor','red',...
    'MarkerSize',9,...
    'LineWidth',0.5);

h3 = plot(1:10,mean_val_SP, 's','MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor','green',...
    'MarkerSize',9,...
    'LineWidth',0.5);

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
xlim([ 1 10]);
% ylim([ 0.67 1]);
xlabel('Number of Features','interpreter','latex')
% ylabel('Specificity','interpreter','latex')
legend([h1,h2,h3] , 'Accuracy', 'Sensitivity','Specificity','location','southeast');
grid on; box on

matlab2tikz('filename',sprintf('AbdulGhani_val_from_train_SPs_balanced.tex'));
hgexport(gcf, 'AbdulGhani_val_from_train_SPS_balanced.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('AbdulGhani_val_from_train_SPS_balanced.fig')

%%
figure(2)
N = 3; % Number of colors to be used

% Use Brewer-map color scheme SET1

axes('ColorOrder',brewermap(N,'Accent'),'NextPlot','replacechildren')

hold on

errorbar(1:10,(min_tr_ACC+max_tr_ACC)/2,(max_tr_ACC-min_tr_ACC)/2,...
    '-s','MarkerSize',.1,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue',...
    'LineStyle','none','Color', 'blue')

errorbar(1:10,(min_tr_SEN+max_tr_SEN)/2,(max_tr_SEN-min_tr_SEN)/2,...
    '-s','MarkerSize',.1,...
    'MarkerEdgeColor','red','MarkerFaceColor','red',...
    'LineStyle','none','Color', 'red' )




errorbar(1:10,(min_tr_SP+max_tr_SP)/2,(max_tr_SP-min_tr_SP)/2,...
    '-s','MarkerSize',.1,...
    'MarkerEdgeColor','green','MarkerFaceColor','green',...
    'LineStyle','none','Color', 'green')

h1 = plot(1:10,mean_tr_ACC, 's','MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor','blue',...
    'MarkerSize',9,...
    'LineWidth',0.5);

h2 = plot(1:10,mean_tr_SEN, 's','MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor','red',...
    'MarkerSize',9,...
    'LineWidth',0.5);

h3 = plot(1:10,mean_tr_SP, 's','MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor','green',...
    'MarkerSize',9,...
    'LineWidth',0.5);

% plot(1:10,mean_tr_ACC, 's','MarkerEdgeColor',[0 0 0],...
%     'MarkerFaceColor',[0.5 0.5 0.5],...
%     'MarkerSize',9,...
%     'LineWidth',0.5);

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
% xlim([ 0 120]);
% ylim([ 0.67 1]);
xlabel('Number of Features','interpreter','latex')
% ylabel('Specificity','interpreter','latex')
legend([h1,h2,h3],'Accuracy', 'Sensitivity','Specificity','location','southeast');
grid on; box on

matlab2tikz('filename',sprintf('AbdulGhani_tra_SPs_balanced.tex'));
hgexport(gcf, 'AbdulGhani_tra_SPS_balanced.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('AbdulGhani_tra_SPS_balanced.fig')