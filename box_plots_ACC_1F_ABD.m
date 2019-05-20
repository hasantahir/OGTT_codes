clear all;clc;clf;close all;

% Generate rbox plots of ranked features

load TpV_1F_ABD TpV
ACC = [TpV.acc];
rows = size(TpV,2);
cols = size(TpV(1).features,2);
ACC = reshape(ACC.', [cols, rows]).';

features = TpV(1).features;

% Basic features
acc_age = ACC(:,1);

acc_ETHN = ACC(:,2);
acc_BMI = ACC(:,3);
acc_PG0 = ACC(:,4);
acc_PG120 = ACC(:,5);
acc_AuG0_120 = ACC(:,6);


acc_IG0_30 = ACC(:,7);
acc_IGM0_30 = ACC(:,8);
acc_IGM0_120 = ACC(:,9);

acc_mat = ACC(:,10);



%% All other features

% % Area under the glucose curve
ft_cat = [acc_age, acc_ETHN,...
    acc_BMI, acc_PG0,...
    acc_PG120, acc_AuG0_120,...
    acc_IG0_30, acc_IGM0_30, ...
    acc_IGM0_120, acc_mat];
group = [1:10];

% % Glucose
aboxplot(ft_cat,'labels',group,'Colorgrad','green_up',...
    'OutlierMarker','+',...
    'OutlierMarkerSize',2.5,...
    'fence_color','black'); % Advanced box plot

% legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('Features','interpreter','latex'); % Add a legend
 
ylabel('Validation Accuracy','interpreter','latex'); % Add a legend

ax = gca;
ax.XTick = group;
ax.XTickLabel = {'Age','ETHN','BMI','PG0',...
    'PG120','AuC-G_{0-120}','\Delta I/\Delta G_{0-30}','\Delta I/\Delta G M_{0-30}',...
    '\Delta I/\Delta G M_{0-120}','Matsuda'};
ax.XTickLabelRotation = 270;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_ACC_1F_ABD.tex'));
hgexport(gcf, 'boxpl_ACC_1F_ABD.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_ACC_1F_ABD.fig')
print(gcf,'boxpl_ACC_1F_ABD.png','-dpng','-r900');


