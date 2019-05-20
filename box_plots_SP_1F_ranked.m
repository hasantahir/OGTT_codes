clear all;clc;clf;close all;

% Generate rbox plots of ranked features

load TpV_1F_ranked TpV
SP = [TpV.sp];
rows = size(TpV,2);
cols = size(TpV(1).features,2);
SP = reshape(SP.', [cols, rows]).';

features = TpV(1).features;

% Basic features
sp_ethn = SP(:,1);

sp_SlG30_0 = SP(:,2);
sp_SlG60_30 = SP(:,3);
sp_SlG60_0 = SP(:,4);
sp_SlG120_0 = SP(:,5);
sp_SlG120_60 = SP(:,6);


sp_SlI60_0 = SP(:,7);
sp_SlI120_0 = SP(:,8);
sp_SlI120_60 = SP(:,9);

sp_AuG0_120 = SP(:,10);
sp_AuG30_120 = SP(:,11);
sp_AuG60_120 = SP(:,12);


%% All other features

% % Area under the glucose curve
ft_cat = [sp_ethn, sp_SlG30_0,...
    sp_SlG60_30, sp_SlG60_0,...
    sp_SlG120_0, sp_SlG120_60,...
    sp_SlI60_0, sp_SlI120_0, ...
    sp_SlI120_60, sp_AuG0_120,...
    sp_AuG30_120, sp_AuG60_120];
% group = [1:12];
group = [1*ones(size(sp_ethn)); 2*ones(size(sp_ethn));...
    3*ones(size(sp_ethn)); 4*ones(size(sp_ethn));...
    5*ones(size(sp_ethn)); 6*ones(size(sp_ethn));...
    7*ones(size(sp_ethn)); 8*ones(size(sp_ethn));...
    9*ones(size(sp_ethn)); 10*ones(size(sp_ethn));...
    11*ones(size(sp_ethn)); 12*ones(size(sp_ethn))];
positions = [1:12];

boxplot(ft_cat,group, 'positions', positions);
color = ['r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r'];
h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.25);
 end
% % Glucose
% aboxplot(ft_cat,'labels',group,'Colorgrad','red_up',...
%     'OutlierMarker','+',...
%     'OutlierMarkerSize',2.5,...
%     'fence_color','black'); % Advanced box plot

% boxplot(ft_cat)

% legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('Features','interpreter','latex'); % Add a legend
 
ylabel('Validation Specificity','interpreter','latex'); % Add a legend

ax = gca;
ax.XTick = positions;
set(gca,'TickLabelInterpreter', 'tex');
ax.XTickLabel = {'ETHN','Sl-Gl_{30-0}','Sl-Gl_{60-30}','Sl-Gl_{60-0}',...
    'Sl-Gl_{120-0}','Sl-Gl_{120-60}','Sl-In_{60-0}','Sl-In_{120-0}',...
    'Sl-In_{120-60}','AuC-Gl_{0-120}','AuC-Gl_{30-120}','AuC-Gl_{60-120}'};
ax.XTickLabelRotation = 270;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
% matlab2tikz('filename',sprintf('boxpl_SP_1F_ranked.tex'));
% hgexport(gcf, 'boxpl_SP_1F_ranked.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
% savefig('boxpl_SP_1F_ranked.fig')
% print(gcf,'boxpl_SP_1F_ranked.png','-dpng','-r900');


