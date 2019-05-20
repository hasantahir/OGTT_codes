clear all;clc;clf;close all;

% Generate rbox plots of ranked features

load data_plus_features_ranked.mat


% Basic features
Glucose = table2array(SAHS_features(:,4:7));
Insulin = table2array(SAHS_features(:,8:11));
BMI = table2array(SAHS_features(:,3));

AuG0_120 = ft.A_G_0_120;
AuG30_120 = ft.A_G_30_120;
AuG60_120 = ft.A_G_60_120;


SlG30_0 = ft.Sl_G_30_0;
SlG60_0 = ft.Sl_G_60_0;
SlG60_30 = ft.Sl_G_60_30;
SlG120_0 = ft.Sl_G_120_0;
SlG120_60 = ft.Sl_G_120_60;

SlI60_0 = ft.Sl_I_60_0;
SlI120_0 = ft.Sl_I_120_0;
SlI120_60 = ft.Sl_I_120_60;

ETHN = ft.ETHN;
% The computed features are stored from 17-60 columns
labels = Labels;

%%% Variable information
% Data -- table of all extracted and some raw features like age and BMI
% label  -- classifier ( 0 or 1)
% Construct positive and negative class
labels(labels==1) = 0; labels(labels==2) = 0; %negative class (Non DMI)
labels(labels==3) = 1; labels(labels==4) = 1; %positive class (DMI)

% Find DMI samples
idx = find (labels == 1);
% r = rem(length(idx),10); %calculates remainder
dmi_length = length(idx); %this will be subset length


% Glucose curve
Glucose_dmi  = Glucose(idx, :);
Glucose_healthy = Glucose;
Glucose_healthy(idx,:)  = []; %deletes the dmi indices


% Insulin curve
Insulin_dmi  = Insulin(idx, :);
Insulin_healthy = Insulin;
Insulin_healthy(idx,:)  = []; %deletes the dmi indices

% Ethnicity
ETHN_dmi  = ETHN(idx, :);
ETHN_healthy = ETHN;
ETHN_healthy(idx,:)  = []; %deletes the dmi indices

% BMI
% max_BMI = max(max(BMI));
BMI_dmi  = BMI(idx, :);
BMI_healthy = BMI;
BMI_healthy(idx,:)  = []; %deletes the dmi indices

% Normalized Area under the Glucose curve
max_AuG0_120 = max(max(AuG0_120));
AuG0_120_dmi  = AuG0_120(idx, :)/max_AuG0_120;
AuG0_120_healthy = AuG0_120/max_AuG0_120;
AuG0_120_healthy(idx,:)  = []; %deletes the dmi indices

max_AuG30_120 = max(max(AuG30_120));
AuG30_120_dmi  = AuG30_120(idx, :)/max_AuG30_120;
AuG30_120_healthy = AuG30_120/max_AuG30_120;
AuG30_120_healthy(idx,:)  = []; %deletes the dmi indices

max_AuG60_120 = max(max(AuG60_120));
AuG60_120_dmi  = AuG60_120(idx, :)/max_AuG60_120;
AuG60_120_healthy = AuG60_120/max_AuG60_120;
AuG60_120_healthy(idx,:)  = []; %deletes the dmi indices



% Normalized Glucose slopes 
max_SlG30_0 = max(max(abs(SlG30_0)));
SlG30_0_dmi  = SlG30_0(idx, :)/max_SlG30_0;
SlG30_0_healthy = SlG30_0/max_SlG30_0;
SlG30_0_healthy(idx,:)  = []; %deletes the dmi indices

max_SlG60_0 = max(max(abs(SlG60_0))); 
SlG60_0_dmi  = SlG60_0(idx, :)/max_SlG60_0;
SlG60_0_healthy = SlG60_0/max_SlG60_0;
SlG60_0_healthy(idx,:)  = []; %deletes the dmi indices

max_SlG60_30 = max(max(abs(SlG60_30))); 
SlG60_30_dmi  = SlG60_30(idx, :)/max_SlG60_30;
SlG60_30_healthy = SlG60_30/max_SlG60_30;
SlG60_30_healthy(idx,:)  = []; %deletes the dmi indices

max_SlG120_0 = max(max(abs(SlG120_0))); 
SlG120_0_dmi  = SlG120_0(idx, :)/max_SlG120_0;
SlG120_0_healthy = SlG120_0/max_SlG120_0;
SlG120_0_healthy(idx,:)  = []; %deletes the dmi indices

max_SlG120_60 = max(max(abs(SlG120_60))); 
SlG120_60_dmi  = SlG120_60(idx, :)/max_SlG120_60;
SlG120_60_healthy = SlG120_60/max_SlG120_60;
SlG120_60_healthy(idx,:)  = []; %deletes the dmi indices

% Normalized Insulin slopes 
max_SlI60_0 = max(max(abs(SlI60_0)));
SlI60_0_dmi  = SlI60_0(idx, :)/max_SlI60_0;
SlI60_0_healthy = SlI60_0/max_SlI60_0;
SlI60_0_healthy(idx,:)  = []; %deletes the dmi indices

max_SlI120_60 = max(max(abs(SlI120_60))); 
SlI120_60_dmi  = SlI120_60(idx, :)/max_SlI120_60;
SlI120_60_healthy = SlI120_60/max_SlI120_60;
SlI120_60_healthy(idx,:)  = []; %deletes the dmi indices

max_SlI120_0 = max(max(abs(SlI120_0))); 
SlI120_0_dmi  = SlI120_0(idx, :)/max_SlI120_0;
SlI120_0_healthy = SlI120_0/max_SlI120_0;
SlI120_0_healthy(idx,:)  = []; %deletes the dmi indices

AuG_healthy = [ AuG0_120_healthy , AuG30_120_healthy, AuG60_120_healthy];
AuG_dmi = [ AuG0_120_dmi , AuG30_120_dmi, AuG60_120_dmi];

Slope_G_healthy = [ SlG30_0_healthy , SlG60_0_healthy ,SlG60_30_healthy , SlG120_60_healthy, SlG120_0_healthy];
Slope_G_dmi = [ SlG30_0_dmi , SlG60_0_dmi , SlG60_30_dmi , SlG120_60_dmi, SlG120_0_dmi];

Slope_I_healthy = [  SlI60_0_healthy , SlI120_60_healthy];
Slope_I_dmi = [ SlI60_0_dmi, SlI120_60_dmi];

demo_healthy = [  BMI_healthy, ETHN_healthy];
demo_dmi = [  BMI_dmi , ETHN_dmi];

red = [128/255 0 0];
green = [0 100/255 0];
%% make boxplots of ranked features
figure(1)

% % Glucose
aboxplot(Glucose_healthy,'labels',[0,30,60,120],'Colorgrad','green_down',...
    'OutlierMarker','o',...
    'OutlierMarkerSize',0.5,...
    'fence_color',green,...
    'median_color','black',...
    'outMarkerEdgeColor',green,...
    'outMarkerFaceColor',green,...
    'edge_color','black'); % Advanced box plot
hold on
aboxplot(Glucose_dmi,'labels',[0,30,60,120],'Colorgrad','red_down',...
    'OutlierMarker','+',...
    'OutlierMarkerSize',0.5,...
    'fence_color',red,...
    'median_color','black',...
    'outMarkerEdgeColor',red,...
    'outMarkerFaceColor',red,...
    'edge_color','black'); % Advanced box plot
ylim([40 250])
legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('$t$ [minutes]','interpreter','latex'); % Add a legend
ylabel('Glucose [mg/dL]','interpreter','latex'); % Add a legend

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_glucose.tex'));
hgexport(gcf, 'boxpl_glucose.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_glucose.fig')
print(gcf,'boxpl_glucose.png','-dpng','-r1200');


% % Insulin
figure(2)

lgreen = [144/255,238/255,144/255, .75];
lred = [240/255,128/255,128/255, .75];

aboxplot(Insulin_healthy,'labels',[0,30,60,120],'Colorgrad','green_down',...
    'OutlierMarker','o',...
    'OutlierMarkerSize',0.5,...
    'fence_color',green,...
    'median_color','black',...
    'outMarkerEdgeColor',green,...
    'outMarkerFaceColor',green,...
    'edge_color','black'); % Advanced box plot
hold on
aboxplot(Insulin_dmi,'labels',[0,30,60,120],'Colorgrad','red_down',...
    'OutlierMarker','+',...
    'OutlierMarkerSize',0.5,...
    'fence_color',red,...
    'median_color','black',...
    'outMarkerEdgeColor',red,...
    'outMarkerFaceColor',red,...
    'edge_color','black'); % Advanced box plot
ylim([0 250])
legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('$t$ [minutes]','interpreter','latex'); % Add a legend
ylabel('Insulin [mg/dL]','interpreter','latex'); % Add a legend

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_Insulin.tex'));
hgexport(gcf, 'boxpl_Insulin.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_Insulin.fig')
print(gcf,'boxpl_insulin.png','-dpng','-r1200');


%% All other features

% % Area under the glucose curve
figure(3)

% % Glucose
aboxplot(AuG_healthy,'labels',[1,2,3],'Colorgrad','green_down',...
    'OutlierMarker','o',...
    'OutlierMarkerSize',0.5,...
    'fence_color',green,...
    'median_color','black',...
    'outMarkerEdgeColor',green,...
    'outMarkerFaceColor',green,...
    'edge_color','black'); % Advanced box plot
hold on
aboxplot(AuG_dmi,'labels',[0,30,60,120],'Colorgrad','red_down',...
    'OutlierMarker','+',...
    'OutlierMarkerSize',0.5,...
    'fence_color',red,...
    'median_color','black',...
    'outMarkerEdgeColor',red,...
    'outMarkerFaceColor',red,...
    'edge_color','black'); % Advanced box plot

legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('Time intervals [minutes]','interpreter','latex'); % Add a legend
 
ylabel('Area under the Glucose curve [a.u.]','interpreter','latex'); % Add a legend

ax = gca;
ax.XTick = [1 2 3];
ax.XTickLabel = {'AuC-G_{0-120}','AuC-G_{30-120}','AuC-G_{60-120}'};
ax.XTickLabelRotation = 270;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_AuG.tex'));
hgexport(gcf, 'boxpl_AuG.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_AuG.fig')
print(gcf,'boxpl_AuG.png','-dpng','-r1200');




% % Glucose Slopes
figure(4)

aboxplot(Slope_G_healthy,'labels',[1,2,3,4,5],'Colorgrad','green_down',...
    'OutlierMarker','o',...
    'OutlierMarkerSize',0.5,...
    'fence_color',green,...
    'median_color','black',...
    'outMarkerEdgeColor',green,...
    'outMarkerFaceColor',green,...
    'edge_color','black'); % Advanced box plot
hold on
aboxplot(Slope_G_dmi,'labels',[1,2,3,4,5],'Colorgrad','red_down',...
    'OutlierMarker','+',...
    'OutlierMarkerSize',0.5,...
    'fence_color',red,...
    'median_color','black',...
    'outMarkerEdgeColor',red,...
    'outMarkerFaceColor',red,...
    'edge_color','black'); % Advanced box plot

legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('Time intervals [minutes]','interpreter','latex'); % Add a legend
ylabel('Slopes of the Glucose curve [a.u.]','interpreter','latex'); % Add a legend

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
ax.XTick = [1 2 3 4 5];
ax.XTickLabel = {'Sl-Gl_{30-0}','Sl-Gl_{60-0}','Sl-Gl_{60-30}','Sl-Gl_{120-60}',...
    'Sl-Gl_{120-0}'};
ax.XTickLabelRotation = 270;

matlab2tikz('filename',sprintf('boxpl_SlG.tex'));
hgexport(gcf, 'boxpl_SlG.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_SlG.fig')
print(gcf,'boxpl_Sl_glucose.png','-dpng','-r1200');




% % Insulin Slopes
figure(5)
aboxplot(Slope_I_healthy,'labels',[1,2],'Colorgrad','green_down',...
    'OutlierMarker','o',...
    'OutlierMarkerSize',0.5,...
    'fence_color',green,...
    'median_color','black',...
    'outMarkerEdgeColor',green,...
    'outMarkerFaceColor',green,...
    'edge_color','black'); % Advanced box plot
hold on
aboxplot(Slope_I_dmi,'labels',[1,2],'Colorgrad','red_down',...
    'OutlierMarker','+',...
    'OutlierMarkerSize',0.5,...
    'fence_color',red,...
    'median_color','black',...
    'outMarkerEdgeColor',red,...
    'outMarkerFaceColor',red,...
    'edge_color','black'); % Advanced box plot

legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('Time intervals [minutes]','interpreter','latex'); % Add a legend
ylabel('Slopes of the Insulin curve [a.u.]','interpreter','latex'); % Add a legend

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
ax.XTick = [1 2];
ax.XTickLabel = {'60-0','120-60'};
matlab2tikz('filename',sprintf('boxpl_SlI.tex'));
hgexport(gcf, 'boxpl_SlI.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_SlI.fig')
print(gcf,'boxpl_Sl_Insulin.png','-dpng','-r1200');




% % BMI and Ethnicity
figure(6)
aboxplot(demo_healthy,'labels',[1,2],'Colorgrad','green_down',...
    'OutlierMarker','o',...
    'OutlierMarkerSize',0.5,...
    'fence_color',green,...
    'median_color','black',...
    'outMarkerEdgeColor',green,...
    'outMarkerFaceColor',green,...
    'edge_color','black'); % Advanced box plot
hold on
aboxplot(demo_dmi,'labels',[1,2],'Colorgrad','red_down',...
    'OutlierMarker','+',...
    'OutlierMarkerSize',0.5,...
    'fence_color',red,...
    'median_color','black',...
    'outMarkerEdgeColor',red,...
    'outMarkerFaceColor',red,...
    'edge_color','black'); % Advanced box plot

legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('Time intervals [minutes]','interpreter','latex'); % Add a legend
 
ylabel('BMI [a.u.]','interpreter','latex'); % Add a legend
ax = gca;
ax.XTick = [1 2];
ax.XTickLabel = {'BMI','ETHN'};
xlim([0.5 1.5])
% ylim([0 1])
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('boxpl_demo.tex'));
hgexport(gcf, 'boxpl_demo.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
print(gcf,'boxpl_demo.png','-dpng','-r1200');
savefig('boxpl_demo.fig')