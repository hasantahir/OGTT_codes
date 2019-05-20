clear all; close all; clc;

% Age and BMI are included as features
warning('off','all') % To supress warnings due to svmtrain and svmclassify

% First weed out all the rows with any zero values
% load data_plus_finite_features.mat
% load features_finite_features_eth.mat
% load feature_AbdulGhani
% load data_plus_features_ranked
% load data_plus_features_combined
load data_plus_features_best4

glucose = table2array(SAHS_features(34, 4:7));
insulin = table2array(SAHS_features(34, 8:11));

xx = 1:.05:4;

interp_glucose = interp1(1:4,glucose,xx,'pchip');
interp_insulin = interp1(1:4,insulin,xx,'pchip');

h1 = plot(xx, interp_glucose, 'linewidth', 1.4)
hold on
h2 = plot(xx ,interp_insulin, 'linewidth', 1.4)

plot(glucose,'o')
plot(insulin,'s')
ax = gca;
ax.XTick = [1 2 3 4 ];
ax.XTickLabel = {'Baseline','30','60','120'};
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
legend([h1 h2 ], 'Glucose','Insulin')
matlab2tikz('filename',sprintf('features_define.tex'));

hgexport(gcf, 'features_define.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('features_define.fig')
print(gcf,'features_define.png','-dpng','-r1200');
print('features_define','-dpdf')