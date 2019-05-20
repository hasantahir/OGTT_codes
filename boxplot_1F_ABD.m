clear all;clc;clf;close all;

% Generate rbox plots of ranked features

load feature_AbdulGhani.mat


% Basic features
Glucose = table2array(SAHS_features(:,4:7));
Insulin = table2array(SAHS_features(:,8:11));
AuG = ft.A_G_0_120;
IG = ft.IG_0_30;
MT = ft.Matsuda;
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

% Normalized Area under the Glucose curve
max_AuG = max(max(AuG));
AuG_dmi  = AuG(idx, :)/max_AuG;
AuG_healthy = AuG/max_AuG;
AuG_healthy(idx,:)  = []; %deletes the dmi indices

% Normalized IG0-30 curve
max_IG = max(max(IG));
IG_dmi  = IG(idx, :)/max_IG;
IG_healthy = IG/max_IG;
IG_healthy(idx,:)  = []; %deletes the dmi indices

% Normalized Matsuda Index
max_MT = max(max(MT));
MT_dmi  = MT(idx, :)/max_MT;
MT_healthy = MT/max_MT;
MT_healthy(idx,:)  = []; %deletes the dmi indices


%% make boxplots of ranked features
figure(1)

% % Glucose
aboxplot(Glucose_healthy,'labels',[0,30,60,120],'Colorgrad','green_up',...
    'OutlierMarker','s',...
    'OutlierMarkerSize',1.5); % Advanced box plot
hold on
aboxplot(Glucose_dmi,'labels',[0,30,60,120],'Colorgrad','green_down',...
    'OutlierMarker','s',...
    'OutlierMarkerSize',1.5); % Advanced box plot
ylim([50 300])
legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('$t$ [minutes]','interpreter','latex'); % Add a legend
ylabel('Glucose [mg/dL]','interpreter','latex'); % Add a legend

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
% matlab2tikz('filename',sprintf('boxpl_glucose.tex'));
% hgexport(gcf, 'boxpl_glucose.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
print(gcf,'boxpl_glucose.png','-dpng','-r900');
savefig('boxpl_glucose.fig')


% % Insulin
figure(2)

aboxplot(Insulin_healthy,'labels',[0,30,60,120],'Colorgrad','red_up',...
    'OutlierMarker','o',...
    'OutlierMarkerSize',2.5); % Advanced box plot
hold on
aboxplot(Insulin_dmi,'labels',[0,30,60,120],'Colorgrad','red_down',...
    'OutlierMarker','+',...
    'OutlierMarkerSize',2.5); % Advanced box plot
ylim([0 400])
legend('Healthy','Diabetic','interpreter','latex'); % Add a legend
xlabel('$t$ [minutes]','interpreter','latex'); % Add a legend
ylabel('Glucose [mg/dL]','interpreter','latex'); % Add a legend

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
% matlab2tikz('filename',sprintf('boxpl_Insulin.tex'));
hgexport(gcf, 'boxpl_Insulin.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_Insulin.fig')


%% All other features

% % Area under the glucose curve
figure(3)
ft_cat = [AuG_healthy; AuG_dmi;...
    IG_healthy; IG_dmi;...
    MT_healthy; MT_dmi];
group = [1*ones(size(AuG_healthy)); 2*ones(size(AuG_dmi));...
    3*ones(size(IG_healthy)); 4*ones(size(IG_dmi));...
    5*ones(size(MT_healthy)); 6*ones(size(MT_dmi))];
positions = [1 1.25 2 2.25 3 3.25];


aboxplot(AuG_healthy,'Colorgrad','green_up',...
    'OutlierMarker','s',...
    'OutlierMarkerSize',1.5); % Advanced box plot

hold on 

aboxplot(AuG_dmi,'Colorgrad','green_down',...
    'OutlierMarker','s',...
    'OutlierMarkerSize',1.5); % Advanced box plot

% boxplot(ft_cat,group, 'positions', positions);
% color = ['y', 'y', 'c', 'c', 'b', 'b'];
% h = findobj(gca,'Tag','Box');
%  for j=1:length(h)
%     patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.5);
%  end
%  
% ylabel('Area under the Glucose curve [a.u.]','interpreter','latex'); % Add a legend

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
% matlab2tikz('filename',sprintf('boxpl_AuG.tex'));
hgexport(gcf, 'boxpl_AuG.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('boxpl_AuG.fig')



