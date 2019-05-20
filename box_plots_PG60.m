clear all;clc;clf;close all;

% Generate rbox plots of ranked features
load TpV_1F_ABD TpV
ACC = [TpV.acc];
rows = size(TpV,2);
cols = size(TpV(1).features,2);
ACC = reshape(ACC.', [cols, rows]).';

features = TpV(1).features;

% Basic features
% acc_age = ACC(:,1);

% acc_ETHN = ACC(:,2);
% acc_BMI = ACC(:,3);
acc_PG0 = ACC(:,4);
acc_PG120 = ACC(:,5);
acc_AuG0_120 = ACC(:,6);


% acc_IG0_30 = ACC(:,7);
acc_IGM0_30 = ACC(:,8);
% acc_IGM0_120 = ACC(:,9);

% acc_mat = ACC(:,10);


load TpV_1F_ranked TpV
ACC1 = [TpV.acc];
rows = size(TpV,2);
cols = size(TpV(1).features,2);
ACC1 = reshape(ACC1.', [cols, rows]).';

features = TpV(1).features;

load TpV_PG60 TpV
ACC2 = [TpV.acc];


acc_PG60 = ACC2';
% Basic features
% acc_ethn = ACC(:,1);

acc_SlG30_0 = ACC1(:,2);
acc_SlG60_30 = ACC1(:,3);
acc_SlG60_0 = ACC1(:,4);
acc_SlG120_0 = ACC1(:,5);
acc_SlG120_60 = ACC1(:,6);


acc_SlI60_0 = ACC1(:,7);
acc_SlI120_0 = ACC1(:,8);
acc_SlI120_60 = ACC1(:,9);

acc_AuG0_120 = ACC1(:,10);
acc_AuG30_120 = ACC1(:,11);
acc_AuG60_120 = ACC1(:,12);


% clear all;clc;clf;close all;

% Generate rbox plots of ranked features





%% All other features

% % Area under the glucose curve
ft_cat = [acc_AuG60_120,acc_PG120, acc_PG60,...
    acc_AuG0_120, acc_AuG30_120,...
    acc_SlG60_0, acc_SlG120_0];
group = [1:7];

% % Glucose
aboxplot(ft_cat,'labels',group,'Colorgrad','blue_up',...
    'OutlierMarker','+',...
    'OutlierMarkerSize',2.5,...
    'fence_color','black',...
    'median_color','black',...
    'outMarkerEdgeColor','red',...
    'outMarkerFaceColor','red',...
    'edge_color','black'); % Advanced box plot); % Advanced box plot

% legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('Features','interpreter','latex'); % Add a legend
 
ylabel('Validation Accuracy','interpreter','latex'); % Add a legend

ax = gca;
ax.XTick = group;
ax.XTickLabel = {'AuC-G_{60-120}','PG120','PG60','AuC-G_{0-120}','AuC-G_{30-120}',...
    '\Delta G/\Delta t _{0-60}','\Delta G/\Delta t _{0-120}'};
ax.XTickLabelRotation = 270;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_ACC_1F_best.tex'));
hgexport(gcf, 'boxpl_ACC_1F_best.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_ACC_1F_best.fig')
print(gcf,'boxpl_ACC_1F_best.png','-dpng','-r1000');
% 



