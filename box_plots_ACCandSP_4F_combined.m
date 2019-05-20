clear all;clc;clf;close all;

% Generate rbox plots of ranked features

load TpV_4F_acc_sp TpV
% load TpV_fourF_acc_sp TpV
% load TpV_4F_acc_sp_select TpV
ACC = [TpV.acc];
SP = [TpV.sp];
rows = size(TpV,2);
cols = 20; % size(TpV(1).features,2);
ACC = reshape(ACC.', [cols, rows]).';
SP = reshape(SP.', [cols, rows]).';

% ACC(:, [1,2,5,11]) = [];
% SP(:, [1,2,5,11]) = [];

ACC = ACC(:,[3,7,11,15,20]);
SP = SP(:,[3,7,11,15,20]);

features = TpV(1).features;

% Basic features
% acc_PG60 = ACC(:,1);
% acc_PG120 = ACC(:,2);
% acc_SlG60_0 = ACC(:,3);
% acc_SlG120_0 = ACC(:,4);
% 
% sp_PG60 = SP(:,1);
% sp_PG120 = SP(:,2);
% sp_SlG60_0 = SP(:,3);
% sp_SlG120_0 = SP(:,4);


%% All other features

% % Area under the glucose curve
% ft_cat1 = [acc_PG60, acc_PG120,...
%     acc_SlG60_0, acc_SlG120_0];
% 
% ft_cat2 = [sp_PG60, sp_PG120,...
%     sp_SlG60_0, sp_SlG120_0];
group = [1:5];

figure(1)
% % Glucose
% aboxplot1(SP,'labels',group,'Colorgrad','green_up',...
%     'OutlierMarker','+',...
%     'OutlierMarkerSize',2.5,...
%     'fence_color','black'); % Advanced box plot

% legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
boxplot(ACC)
xlabel('Features','interpreter','latex'); % Add a legend
 
ylabel('Validation Accuracy','interpreter','latex'); % Add a legend

ax = gca;
ax.XTick = group;
% ax.XTickLabel = {'PG_{60},PG_{120},{\Delta I/\Delta G}_{0-30} M ','PG_{60},AuG_{0-120},{\Delta I/\Delta G}_{0-120} M',...
%     'PG_{120},AuG_{0-120},AuG_{60-120}',...
%     'PG_{120},AuG_{60-120},{\Delta I/\Delta G}_{0-120} M',...
%     'AuG_{60-120},{\Delta I/\Delta G}_{0-30} M,{\Delta I/\Delta G}_{0-120} M','interpreter','latex'};
% ax.XTickLabelRotation = 270;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_ACC_4F_sp_acc.tex'));
hgexport(gcf, 'boxpl_ACC_4F_sp_acc.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_ACC_4F_sp_acc.fig')
print(gcf,'boxpl_ACC_4F_sp_acc.png','-dpng','-r900');


figure(2)
% % Glucose
boxplot(SP)
xlabel('Features','interpreter','latex'); % Add a legend
 
ylabel('Validation Accuracy','interpreter','latex'); % Add a legend

ax = gca;
% ax.XTick = group;
% ax.XTickLabel = {'PG_{60},PG_{120},{\Delta I/\Delta G}_{0-30} M ','PG_{60},AuG_{0-120},{\Delta I/\Delta G}_{0-120} M',...
%     'PG_{120},AuG_{0-120},AuG_{60-120}',...
%     'PG_{120},AuG_{60-120},{\Delta I/\Delta G}_{0-120} M',...
%     'AuG_{60-120},{\Delta I/\Delta G}_{0-30} M,{\Delta I/\Delta G}_{0-120} M'};
% ax.XTickLabelRotation = 270;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_SP_4F_sp_acc.tex'));
hgexport(gcf, 'boxpl_SP_4F_sp_acc.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_SP_4F_sp_acc.fig')
print(gcf,'boxpl_SP_4F_sp_acc.png','-dpng','-r900');
