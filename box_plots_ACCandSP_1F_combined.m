clear all;clc;clf;close all;

% Generate rbox plots of ranked features

load TpV_1F_PG60 TpV
ACC = [TpV.acc];
SP = [TpV.sp];
rows = size(TpV,2);
cols = 4; % size(TpV(1).features,2);
ACC = reshape(ACC.', [cols, rows]).';
SP = reshape(SP.', [cols, rows]).';

features = TpV(1).features;

% Basic features
acc_PG60 = ACC(:,1);
acc_PG120 = ACC(:,2);
acc_SlG60_0 = ACC(:,3);
acc_SlG120_0 = ACC(:,4);

sp_PG60 = SP(:,1);
sp_PG120 = SP(:,2);
sp_SlG60_0 = SP(:,3);
sp_SlG120_0 = SP(:,4);


%% All other features

% % Area under the glucose curve
ft_cat1 = [acc_PG60, acc_PG120,...
    acc_SlG60_0, acc_SlG120_0];

ft_cat2 = [sp_PG60, sp_PG120,...
    sp_SlG60_0, sp_SlG120_0];
group = [1:4];

figure(1)
% % Glucose
aboxplot(ft_cat1,'labels',group,'Colorgrad','green_up',...
    'OutlierMarker','+',...
    'OutlierMarkerSize',2.5,...
    'fence_color','black'); % Advanced box plot

% legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('Features','interpreter','latex'); % Add a legend
 
ylabel('Validation Accuracy','interpreter','latex'); % Add a legend

ax = gca;
ax.XTick = group;
ax.XTickLabel = {'PG60','PG120','Sl-Gl_{60-0}',...
    'Sl-Gl_{120-0}'};
ax.XTickLabelRotation = 270;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_ACC_1F_combined.tex'));
hgexport(gcf, 'boxpl_ACC_1F_combined.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_ACC_1F_combined.fig')
print(gcf,'boxpl_ACC_1F_combined.png','-dpng','-r900');


figure(2)
% % Glucose
aboxplot(ft_cat2,'labels',group,'Colorgrad','red_up',...
    'OutlierMarker','+',...
    'OutlierMarkerSize',2.5,...
    'fence_color','black'); % Advanced box plot

% legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('Features','interpreter','latex'); % Add a legend
 
ylabel('Validation Specificity','interpreter','latex'); % Add a legend

ax = gca;
ax.XTick = group;
ax.XTickLabel = {'PG60','PG120','Sl-Gl_{60-0}',...
    'Sl-Gl_{120-0}'};
ax.XTickLabelRotation = 270;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_SP_1F_combined.tex'));
hgexport(gcf, 'boxpl_SP_1F_combined.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_SP_1F_combined.fig')
print(gcf,'boxpl_SP_1F_combined.png','-dpng','-r900');
