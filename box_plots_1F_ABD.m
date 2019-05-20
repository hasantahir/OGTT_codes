clear all;clc;clf;close all;

% Generate rbox plots of ranked features

load TpV_1F_ABD TpV
ACC = [TpV.acc];
rows = size(TpV,2);
cols = size(TpV(1).features,2);
ACC = reshape(ACC.', [cols, rows]).';

features = TpV(1).features;

% Basic features
ABD_acc.AGE = ACC(:,1);

ABD_acc.ETHN = ACC(:,2);
ABD_acc.BMI = ACC(:,3);
ABD_acc.PG0 = ACC(:,4);
ABD_acc.PG120 = ACC(:,5);
ABD_acc.AuG0_120 = ACC(:,6);


ABD_acc.IG0_30 = ACC(:,7);
ABD_acc.IGM0_30= ACC(:,8);
ABD_acc.IG0_120 = ACC(:,9);

ABD_acc.Mat = ACC(:,10);

%% All other features

% % Area under the glucose curve
ft_cat = [ABD_acc.AGE; ABD_acc.ETHN;...
    ABD_acc.BMI; ABD_acc.PG0;...
    ABD_acc.PG120; ABD_acc.AuG0_120;...
    ABD_acc.IG0_30; ABD_acc.IGM0_30; 
    ABD_acc.IG0_120;ABD_acc.Mat];

group = [1*ones(size(ABD_acc.AGE)); 2*ones(size(ABD_acc.AGE));...
    3*ones(size(ABD_acc.AGE)); 4*ones(size(ABD_acc.AGE));...
    5*ones(size(ABD_acc.AGE)); 6*ones(size(ABD_acc.AGE));...
    7*ones(size(ABD_acc.AGE)); 8*ones(size(ABD_acc.AGE));...
    9*ones(size(ABD_acc.AGE)); 10*ones(size(ABD_acc.AGE))];
positions = [1:10];

boxplot(ft_cat,group, 'positions', positions);
color = ['g', 'g', 'g', 'g', 'g', 'g', 'g', 'g', 'g', 'g', 'g', 'g'];
h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.25);
 end
 
ylabel('Validation Accuracy of Ranked Features','interpreter','latex'); % Add a legend


ax = gca;
ax.XTick = [1:10];
set(gca,'TickLabelInterpreter', 'tex');
ax.XTickLabel = {'Age','ETHN','BMI','PG0',...
    'PG120','AuC-G_{0-120}','\Delta I/\Delta G_{0-30}','\Delta I/\Delta G M_{0-30}',...
    '\Delta I/\Delta G M_{0-120}','Matsuda', 'interpreter','latex'};
ax.XTickLabelRotation = 270;
ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_acc_features_ABD.tex'));
hgexport(gcf, 'boxpl_acc_features_ABD.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_acc_features_ABD.fig')
print(gcf,'boxpl_acc_features_ABD.png','-dpng','-r900');

save ABD_acc ABD_acc


