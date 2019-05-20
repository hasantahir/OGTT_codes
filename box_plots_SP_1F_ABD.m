clear all;clc;clf;close all;

% Generate rbox plots of ranked features

load TpV_1F_ABD TpV
SP = [TpV.sp];
rows = size(TpV,2);
cols = size(TpV(1).features,2);
SP = reshape(SP.', [cols, rows]).';

features = TpV(1).features;

% Basic features
sp_age = SP(:,1);

sp_ETHN = SP(:,2);
sp_BMI = SP(:,3);
sp_PG0 = SP(:,4);
sp_PG120 = SP(:,5);
sp_AuG0_120 = SP(:,6);


sp_IG0_30 = SP(:,7);
sp_IGM0_30 = SP(:,8);
sp_IGM0_120 = SP(:,9);

sp_mat = SP(:,10);



%% All other features

% % Area under the glucose curve
ft_cat = [sp_age, sp_ETHN,...
    sp_BMI, sp_PG0,...
    sp_PG120, sp_AuG0_120,...
    sp_IG0_30, sp_IGM0_30, ...
    sp_IGM0_120, sp_mat];
% group = [1:10];

group = [1*ones(size(sp_age)); 2*ones(size(sp_age));...
    3*ones(size(sp_age)); 4*ones(size(sp_age));...
    5*ones(size(sp_age)); 6*ones(size(sp_age));...
    7*ones(size(sp_age)); 8*ones(size(sp_age));...
    9*ones(size(sp_age)); 10*ones(size(sp_age))];
positions = [1:10];

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
ax.XTick = [1:10];
set(gca,'TickLabelInterpreter', 'tex');
ax.XTickLabel = {'Age','ETHN','BMI','PG0',...
    'PG120','AuC-G_{0-120}','\Delta I/\Delta G_{0-30}','\Delta I/\Delta G M_{0-30}',...
    '\Delta I/\Delta G M_{0-120}','Matsuda', 'interpreter','latex'};
ax.XTickLabelRotation = 270;
ylim([0 1])
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
% matlab2tikz('filename',sprintf('boxpl_SP_1F_ABD.tex'));
% hgexport(gcf, 'boxpl_SP_1F_ABD.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
% savefig('boxpl_SP_1F_ABD.fig')
% print(gcf,'boxpl_SP_1F_ABD.png','-dpng','-r900');
% 

