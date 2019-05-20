clear all;clc;close all;clf

% Generate results that use RBF kernels for SVM training

% load Training_plus_Validation_results_AbdulGhani_unbalanced_100iters Training_plus_Validation_results
% load Training_plus_Validation_results_rankedunbalanced_100iters
load Training_plus_Validation_ABD_10iters

Training_plus_Validation_results = Training_plus_Validation_results;
% Get the accuracies along with their features
numFeatures = size(Training_plus_Validation_results(1).tr_max_acc,2);
numIterations = size(Training_plus_Validation_results,2);

for i = 1 : numFeatures
    
    for j = 1 : numIterations
        
        % Maximized Specificity
        tra_SP(i,j) = Training_plus_Validation_results(j).tr_max_sp(i);
        tra_ACC(i,j) = Training_plus_Validation_results(j).tr_acc_max_sp(i);
        tra_SEN(i,j) = Training_plus_Validation_results(j).tr_sn_max_sp(i);
        tra_Features{i,j} = char((Training_plus_Validation_results(j).features{i}));
        
        val_SP(i,j) = Training_plus_Validation_results(j).val_sp_max_sp(i);
        val_ACC(i,j) = Training_plus_Validation_results(j).val_acc_max_sp(i);        
        val_SEN(i,j) = Training_plus_Validation_results(j).val_sn_max_sp(i);
        val_Features{i,j} = char((Training_plus_Validation_results(j).features{i}));
        
                % Maximized Sensitivity
%         tra_SEN(i,j) = Training_plus_Validation_results(j).tr_max_sn(i);
%         tra_ACC(i,j) = Training_plus_Validation_results(j).tr_acc_max_sn(i);
%         tra_SP(i,j) = Training_plus_Validation_results(j).tr_sp_max_sn(i);
%         tra_Features{i,j} = char((Training_plus_Validation_results(j).features{i}));
%         
%         val_SEN(i,j) = Training_plus_Validation_results(j).val_sn_max_sn(i);
%         val_ACC(i,j) = Training_plus_Validation_results(j).val_acc_max_sn(i);        
%         val_SP(i,j) = Training_plus_Validation_results(j).val_sp_max_sn(i);
%         val_Features{i,j} = char((Training_plus_Validation_results(j).features{i}));
        
%                 % Maximized Accuracy
%         tra_SP(i,j) = Training_plus_Validation_results(j).tr_sp_max_acc(i);
%         tra_ACC(i,j) = Training_plus_Validation_results(j).tr_max_acc(i);
%         tra_SEN(i,j) = Training_plus_Validation_results(j).tr_sn_max_acc(i);
%         tra_Features{i,j} = char((Training_plus_Validation_results(j).features{i}));
%         
%         val_SP(i,j) = Training_plus_Validation_results(j).val_sp_max_acc(i);
%         val_ACC(i,j) = Training_plus_Validation_results(j).val_acc_max_acc(i);        
%         val_SEN(i,j) = Training_plus_Validation_results(j).val_sn_max_acc(i);
%         val_Features{i,j} = char((Training_plus_Validation_results(j).features{i}));
    end
end

%% Accuracy

mean_tra_ACC = mean(tra_ACC, 2);
max_tra_ACC = max(tra_ACC, [], 2);
min_tra_ACC = min(tra_ACC, [], 2);

mean_val_ACC = mean(val_ACC, 2);
max_val_ACC = max(val_ACC, [], 2);
min_val_ACC = min(val_ACC, [], 2);

%% Senstivity


mean_tra_SEN = mean(tra_SEN, 2);
max_tra_SEN = max(tra_SEN, [], 2);
min_tra_SEN = min(tra_SEN, [], 2);

mean_val_SEN = mean(val_SEN, 2);
max_val_SEN = max(val_SEN, [], 2);
min_val_SEN = min(val_SEN, [], 2);

%% Specificity

mean_tra_SP = mean(tra_SP, 2);
std_tra_SP = std(tra_SP,0, 2);
max_tra_SP = max(tra_SP, [], 2);
min_tra_SP = min(tra_SP, [], 2);

mean_val_SP = mean(val_SP, 2);
std_val_SP = std(val_SP,0, 2);
max_val_SP = max(val_SP, [], 2);
min_val_SP = min(val_SP, [], 2);



figure(1)
N = 3; % Number of colors to be used

% Use Brewer-map color scheme SET1

axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')

hold on

errorbar(1:numFeatures,(min_val_ACC+max_val_ACC)/2,(max_val_ACC-min_val_ACC)/2,...
    '-s','MarkerSize',.1,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue',...
    'LineStyle','none','Color', 'blue')

errorbar(1:numFeatures,(min_val_SEN+max_val_SEN)/2,(max_val_SEN-min_val_SEN)/2,...
    '-s','MarkerSize',.1,...
    'MarkerEdgeColor','red','MarkerFaceColor','red',...
    'LineStyle','none','Color', 'red')


errorbar(1:numFeatures,(min_val_SP+max_val_SP)/2,(max_val_SP-min_val_SP)/2,...
    '-s','MarkerSize',.1,...
    'MarkerEdgeColor','green','MarkerFaceColor','green',...
    'LineStyle','none','Color', 'green')

h1 = plot(1:numFeatures,mean_val_ACC, 's','MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor','blue',...
    'MarkerSize',9,...
    'LineWidth',0.5);

h2 = plot(1:numFeatures,mean_val_SEN, 's','MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor','red',...
    'MarkerSize',9,...
    'LineWidth',0.5);

h3 = plot(1:numFeatures,mean_val_SP, 's','MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor','green',...
    'MarkerSize',9,...
    'LineWidth',0.5);


% idx = min ~= max;
% h2 = errorbar(x(idx),y(idx),min(idx), max(idx));

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
xlim([ 1 8]);
% ylim([ 0.67 1]);
xlabel('Number of Features','interpreter','latex')
% ylabel('Specificity','interpreter','latex')
legend([h1,h2,h3] , 'Accuracy', 'Sensitivity','Specificity','location','southeast');
grid on; box on

matlab2tikz('filename',sprintf('ABD_val_SPs.tex'));
hgexport(gcf, 'ABD_val_SPs.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('ABD_val_SPs.fig')

%%
figure(2)

axes('ColorOrder',brewermap(N,'Accent'),'NextPlot','replacechildren')

hold on

errorbar(1:numFeatures,(min_tra_ACC+max_tra_ACC)/2,(max_tra_ACC-min_tra_ACC)/2,...
    '-s','MarkerSize',.1,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue',...
    'LineStyle','none','Color', 'blue')

errorbar(1:numFeatures,(min_tra_SEN+max_tra_SEN)/2,(max_tra_SEN-min_tra_SEN)/2,...
    '-s','MarkerSize',.1,...
    'MarkerEdgeColor','red','MarkerFaceColor','red',...
    'LineStyle','none','Color', 'red' )




errorbar(1:numFeatures,(min_tra_SP+max_tra_SP)/2,(max_tra_SP-min_tra_SP)/2,...
    '-s','MarkerSize',.1,...
    'MarkerEdgeColor','green','MarkerFaceColor','green',...
    'LineStyle','none','Color', 'green')

h1 = plot(1:numFeatures,mean_tra_ACC, 's','MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor','blue',...
    'MarkerSize',9,...
    'LineWidth',0.5);

h2 = plot(1:numFeatures,mean_tra_SEN, 's','MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor','red',...
    'MarkerSize',9,...
    'LineWidth',0.5);

h3 = plot(1:numFeatures,mean_tra_SP, 's','MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor','green',...
    'MarkerSize',9,...
    'LineWidth',0.5);

% plot(1:numFeatures,mean_tr_ACC, 's','MarkerEdgeColor',[0 0 0],...
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

matlab2tikz('filename',sprintf('ABD_tra_SPs.tex'));
hgexport(gcf, 'ABD_tra_SPs.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('ABD_tra_SPs.fig')


%% make box plots of the validation specificity, sensitivity and accracu
figure(3)
N = 3; % Number of colors to be used

% Use Brewer-map color scheme SET1

axes('ColorOrder',brewermap(N,'Accent'),'NextPlot','replacechildren')
xlim([ 1 numFeatures]);
xlabel('Number of Features','interpreter','latex')


hold on

positions = [1:numFeatures];
group = positions;


boxplot(val_SP',group, 'positions', positions)

h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'green','FaceAlpha',.25);
 end
h = boxplot(val_SP',group, 'positions', positions);
ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_ABD_val_SP.tex'));
hgexport(gcf, 'boxpl_ABD_val_SP.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('ABD_val_SP.fig')



% % Sensitivity
figure(4)
xlim([ 1 numFeatures]);
xlabel('Number of Features','interpreter','latex')
ylabel('Sensitivity','interpreter','latex')


hold on

positions = [1:numFeatures];
group = positions;


boxplot(val_SEN',group, 'positions', positions)

h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'red','FaceAlpha',.25);
 end
h = boxplot(val_SEN',group, 'positions', positions);
ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman

matlab2tikz('filename',sprintf('boxpl_ABD_val_SEN.tex'));
hgexport(gcf, 'boxpl_ABD_val_SEN.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('ABD_val_SEN.fig')

% % Accuracy
figure(5)
xlim([ 1 numFeatures]);
xlabel('Number of Features','interpreter','latex')
ylabel('Accuracy','interpreter','latex')

hold on

positions = [1:numFeatures];
group = positions;


boxplot(val_ACC',group, 'positions', positions)

h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'blue','FaceAlpha',.25);
 end
h = boxplot(val_ACC',group, 'positions', positions);
ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_ABD_val_ACC.tex'));
hgexport(gcf, 'boxpl_ABD_val_ACC.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('ABD_val_ACC.fig')


%% Box plots for training models
figure(6)

xlim([ 1 numFeatures]);
xlabel('Number of Features','interpreter','latex')


hold on

positions = [1:numFeatures];
group = positions;


boxplot(tra_SP',group, 'positions', positions)

h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'green','FaceAlpha',.25);
 end
h = boxplot(tra_SP',group, 'positions', positions);
ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_ABD_tra_SP.tex'));
hgexport(gcf, 'boxpl_ABD_tra_SP.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('ABD_tra_SP.fig')



% % Sensitivity
figure(7)
xlim([ 1 numFeatures]);
xlabel('Number of Features','interpreter','latex')
ylabel('Sensitivity','interpreter','latex')


hold on

positions = [1:numFeatures];
group = positions;


boxplot(tra_SEN',group, 'positions', positions)

h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'red','FaceAlpha',.25);
 end
h = boxplot(tra_SEN',group, 'positions', positions);
ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman

matlab2tikz('filename',sprintf('boxpl_ABD_tra_SEN.tex'));
hgexport(gcf, 'boxpl_ABD_tra_SEN.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('ABD_tra_SEN.fig')


% % Accuracy
figure(8)
xlim([ 1 numFeatures]);
xlabel('Number of Features','interpreter','latex')
ylabel('Accuracy','interpreter','latex')

hold on

positions = [1:numFeatures];
group = positions;


boxplot(tra_ACC',group, 'positions', positions)

h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'blue','FaceAlpha',.25);
 end
h = boxplot(tra_ACC',group, 'positions', positions);
ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_ABD_tra_ACC.tex'));
hgexport(gcf, 'boxpl_ABD_tra_ACC.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('ABD_tra_ACC.fig')