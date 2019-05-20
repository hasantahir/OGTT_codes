clear all;clc;clf;close all;

% Generate rbox plots of ranked features

load TpV_1F_ranked TpV
ACC = [TpV.acc];
rows = size(TpV,2);
cols = size(TpV(1).features,2);
ACC = reshape(ACC.', [cols, rows]).';

features = TpV(1).features;

% Basic features
acc_ethn = ACC(:,1);

acc_SlG30_0 = ACC(:,2);
acc_SlG60_30 = ACC(:,3);
acc_SlG60_0 = ACC(:,4);
acc_SlG120_0 = ACC(:,5);
acc_SlG120_60 = ACC(:,6);


acc_SlI60_0 = ACC(:,7);
acc_SlI120_0 = ACC(:,8);
acc_SlI120_60 = ACC(:,9);

acc_AuG0_120 = ACC(:,10);
acc_AuG30_120 = ACC(:,11);
acc_AuG60_120 = ACC(:,12);


%% All other features
ft_cat = [acc_ethn, acc_SlG30_0,...
    acc_SlG60_30, acc_SlG60_0,...
    acc_SlG120_0, acc_SlG120_60,...
    acc_SlI60_0, acc_SlI120_0, ...
    acc_SlI120_60, acc_AuG0_120,...
    acc_AuG30_120, acc_AuG60_120];
% % Area under the glucose curve
group = [1*ones(size(acc_ethn)); 2*ones(size(acc_ethn));...
    3*ones(size(acc_ethn)); 4*ones(size(acc_ethn));...
    5*ones(size(acc_ethn)); 6*ones(size(acc_ethn));...
    7*ones(size(acc_ethn)); 8*ones(size(acc_ethn));...
    9*ones(size(acc_ethn)); 10*ones(size(acc_ethn));...
    11*ones(size(acc_ethn)); 12*ones(size(acc_ethn))];
positions = [1:12];

boxplot(ft_cat,group, 'positions', positions);
color = ['g', 'g', 'g', 'g', 'g', 'g', 'g', 'g', 'g', 'g', 'g', 'g'];
h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.25);
 end
% % Glucose
% aboxplot(ft_cat,'labels',group,'Colorgrad','green_up',...
%     'OutlierMarker','+',...
%     'OutlierMarkerSize',2.5,...
%     'fence_color','black'); % Advanced box plot

% legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('Features','interpreter','latex'); % Add a legend
 
ylabel('Validation Accuracy','interpreter','latex'); % Add a legend

ax = gca;
ax.XTick = positions;
set(gca,'TickLabelInterpreter', 'tex');
ax.XTickLabel = {'ETHN','Sl-Gl_{30-0}','Sl-Gl_{60-30}','Sl-Gl_{60-0}',...
    'Sl-Gl_{120-0}','Sl-Gl_{120-60}','Sl-In_{60-0}','Sl-In_{120-0}',...
    'Sl-In_{120-60}','AuC-Gl_{0-120}','AuC-Gl_{30-120}','AuC-Gl_{60-120}'};
ax.XTickLabelRotation = 270;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_ACC_1F_ranked.tex'));
hgexport(gcf, 'boxpl_ACC_1F_ranked.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_ACC_1F_ranked.fig')
print(gcf,'boxpl_ACC_1F_ranked.png','-dpng','-r900');


