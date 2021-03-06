clear all;clc;close all;clf

load Training_results_AbdulGhani_20 Training_results
load Validation_results_AbdulGhani_20 Validation_results


% Get the accuracies along with their features
numFeatures = size(Training_results(1).max_acc,2);
numIterations = size(Training_results,2);

for i = 1 : numFeatures
    
    for j = 1 : numIterations
        
        tr_SP(i,j) = Training_results(j).max_sp(i);
        tr_ACC(i,j) = Training_results(j).acc_max_sp(i);
        tr_SEN(i,j) = Training_results(j).sn_max_sp(i);
        tr_Features{i,j} = char((Training_results(j).features{i}));
        
        val_SP(i,j) = Validation_results(j).max_sp(i);
        val_ACC(i,j) = Validation_results(j).acc_max_sp(i);        
        val_SEN(i,j) = Validation_results(j).sn_max_sp(i);
        val_Features{i,j} = char((Validation_results(j).features{i}));
    end
end

%% Accuracy

mean_tr_ACC = mean(tr_ACC, 2);
max_tr_ACC = max(tr_ACC, [], 2);
min_tr_ACC = min(tr_ACC, [], 2);

mean_val_ACC = mean(val_ACC, 2);
max_val_ACC = max(val_ACC, [], 2);
min_val_ACC = min(val_ACC, [], 2);

figure(1)
N = 2; % Number of colors to be used

% Use Brewer-map color scheme SET1

axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')

hold on

errorbar(1:10,(min_tr_ACC+max_tr_ACC)/2,(max_tr_ACC-min_tr_ACC)/2,...
    '-s','MarkerSize',10,...
    'MarkerEdgeColor','red','MarkerFaceColor','red',...
    'LineStyle','none')

errorbar(1:10,(min_val_ACC+max_val_ACC)/2,(max_val_ACC-min_val_ACC)/2,...
    '-s','MarkerSize',10,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue',...
    'LineStyle','none')

% plot(1:10,max_tr_ACC, 's','MarkerEdgeColor',[0 0 0],...
%     'MarkerFaceColor',[0.5 0.5 0.5],...
%     'MarkerSize',9,...
%     'LineWidth',0.5);
% 
% plot(1:10,min_tr_ACC, 's','MarkerEdgeColor',[0 0 0],...
%     'MarkerFaceColor',[0.5 0.5 0.5],...
%     'MarkerSize',9,...
%     'LineWidth',0.5);
% 
% plot(1:10,max_val_ACC, 's','MarkerEdgeColor',[0 0 0],...
%     'MarkerFaceColor',[0.9 0.9 0.9],...
%     'MarkerSize',9,...
%     'LineWidth',1);
% 
% plot(1:10,min_val_ACC, 's','MarkerEdgeColor',[0 0 0],...
%     'MarkerFaceColor',[0.9 0.9 0.9],...
%     'MarkerSize',9,...
%     'LineWidth',1);

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
xlim([ 1 10]);
% ylim([ 0.67 1]);
xlabel('Number of Features','interpreter','latex')
ylabel('Accuracy','interpreter','latex')
legend('Training', 'Validation','location','southeast');
grid on; box on
matlab2tikz('filename',sprintf('AbdulGhani_ACC_sp.tex'));
hgexport(gcf, 'AbdulGhani_ACC_sp.jpg', hgexport('factorystyle'), 'Format', 'jpeg');

%% Senstivity

figure(2)

mean_tr_SEN = mean(tr_SEN, 2);
max_tr_SEN = max(tr_SEN, [], 2);
min_tr_SEN = min(tr_SEN, [], 2);

mean_val_SEN = mean(val_SEN, 2);
max_val_SEN = max(val_SEN, [], 2);
min_val_SEN = min(val_SEN, [], 2);

N = 2; % Number of colors to be used

% Use Brewer-map color scheme SET1
axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')

hold on

errorbar(1:10,(min_tr_SEN+max_tr_SEN)/2,(max_tr_SEN-min_tr_SEN)/2,...
    '-s','MarkerSize',10,...
    'MarkerEdgeColor','red','MarkerFaceColor','red',...
    'LineStyle','none')

errorbar(1:10,(min_val_SEN+max_val_SEN)/2,(max_val_SEN-min_val_SEN)/2,...
    '-s','MarkerSize',10,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue',...
    'LineStyle','none')

% plot(1:10,max_tr_SEN, 's','MarkerEdgeColor',[0 0 0],...
%     'MarkerFaceColor',[0.5 0.5 0.5],...
%     'MarkerSize',9,...
%     'LineWidth',0.5);
% 
% plot(1:10,min_tr_SEN, 's','MarkerEdgeColor',[0 0 0],...
%     'MarkerFaceColor',[0.5 0.5 0.5],...
%     'MarkerSize',9,...
%     'LineWidth',0.5);
% 
% plot(1:10,max_val_SEN, 's','MarkerEdgeColor',[0 0 0],...
%     'MarkerFaceColor',[0.9 0.9 0.9],...
%     'MarkerSize',9,...
%     'LineWidth',1);
% 
% plot(1:10,min_val_SEN, 's','MarkerEdgeColor',[0 0 0],...
%     'MarkerFaceColor',[0.9 0.9 0.9],...
%     'MarkerSize',9,...
%     'LineWidth',1);

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
xlim([ 1 10]);
% ylim([ 0.67 1]);
xlabel('Number of Features','interpreter','latex')
ylabel('Sensitivity','interpreter','latex')
legend('Training', 'Validation','location','southeast');
grid on; box on
matlab2tikz('filename',sprintf('AbdulGhani_SEN_sp.tex'));
hgexport(gcf, 'AbdulGhani_SEN_sp.jpg', hgexport('factorystyle'), 'Format', 'jpeg');




%% Specificity
figure(3)

mean_tr_SP = mean(tr_SP, 2);
std_tr_SP = std(tr_SP,0, 2);
max_tr_SP = max(tr_SP, [], 2);
min_tr_SP = min(tr_SP, [], 2);

mean_val_SP = mean(val_SP, 2);
std_val_SP = std(val_SP,0, 2);
max_val_SP = max(val_SP, [], 2);
min_val_SP = min(val_SP, [], 2);

N = 2; % Number of colors to be used

% Use Brewer-map color scheme SET1
axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')

hold on

errorbar(1:10,(min_tr_SP+max_tr_SP)/2,(max_tr_SP-min_tr_SP)/2,...
    '-s','MarkerSize',10,...
    'MarkerEdgeColor','red','MarkerFaceColor','red',...
    'LineStyle','none')

errorbar(1:10,(min_val_SP+max_val_SP)/2,(max_val_SP-min_val_SP)/2,...
    '-s','MarkerSize',10,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue',...
    'LineStyle','none')

% plot(1:10,max_tr_SP, 's','MarkerEdgeColor',[0 0 0],...
%     'MarkerFaceColor',[0.5 0.5 0.5],...
%     'MarkerSize',9,...
%     'LineWidth',0.5);
% 
% plot(1:10,min_tr_SP, 's','MarkerEdgeColor',[0 0 0],...
%     'MarkerFaceColor',[0.5 0.5 0.5],...
%     'MarkerSize',9,...
%     'LineWidth',0.5);
% 
% plot(1:10,max_val_SP, 's','MarkerEdgeColor',[0 0 0],...
%     'MarkerFaceColor',[0.9 0.9 0.9],...
%     'MarkerSize',9,...
%     'LineWidth',1);
% 
% plot(1:10,min_val_SP, 's','MarkerEdgeColor',[0 0 0],...
%     'MarkerFaceColor',[0.9 0.9 0.9],...
%     'MarkerSize',9,...
%     'LineWidth',1);

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
xlim([ 1 10]);
% ylim([ 0.67 1]);
xlabel('Number of Features','interpreter','latex')
ylabel('Specificity','interpreter','latex')
legend('Training', 'Validation','location','southeast');
grid on; box on
matlab2tikz('filename',sprintf('AbdulGhani_SP_sp.tex'));

hgexport(gcf, 'AbdulGhani_SP_sp.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
