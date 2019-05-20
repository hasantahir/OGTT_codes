% Plot results sensitivity vs specificity
clear all

load M4_Tested_Models M4

% this loads all the models (10 cv * # of features)

% First select the one with best sensitivity

for jj = 1 : 1
    % find the size of all models object
    len = size(M4(jj).models,2);
    
    models = M4(jj).models;
    
    % for each feature, find the best model, specifity, sensitivity,
    % accuracy-wise
    for i = 1 : len
        temp = models(i).models;
        for k = 1 : 10
            model = cell2mat(temp(k)); % convert in order to access cell properties
            SP(i,k) = model.Specificity;
            SN(i,k) = model.Sensitivity;
            ACC(i,k) = model.LastCorrectRate;
        end
    end
    SP = SP';
    SN = SN';
    ACC = ACC';
    
    
    % find indices of maximum accuracy, sensitivity and specificities
    
    [acc_r, acc_c] = find(ACC == (max(ACC)));
    % acc_r = unique(acc_r); % use only unique indices
    % acc_c = unique(acc_c);
    
    [accmax,I] = max(ACC(:));
    [accmax_r, accmax_c] = ind2sub(size(ACC),I);
    %
    % [sp,I] = max(SP);
    % [sp_r, sp_c] = ind2sub(size(SP),I);
    %
    % [sn,I] = max(SN);
    % [sn_r, sn_c] = ind2sub(size(SN),I);
    
    [sp_r, sp_c] = find(SP == max(max(SP)));
    % sp_r = unique(sp_r);
    % sp_c = unique(sp_c);
    
    [spmax,I] = max(SP(:));
    [spmax_r, spmax_c] = ind2sub(size(SP),I);
    
    [sn_r, sn_c] = find(SN == max(max(SN)));
    % sn_r = unique(sn_r);
    % sn_c = unique(sn_c);
    
    [snmax,I] = max(SN(:));
    [snmax_r, snmax_c] = ind2sub(size(SN),I);
    
    % Confusion Matrix for the highest accuracy model
    CP = models(accmax_c).models;
    CP = cell2mat(CP(accmax_r));
    CM = CP.CountingMatrix;
    
    
    
    %% Find respective accuracy and sensitivity for model with highest SP
    
    sp = max(SP);
    
    % Accuracy for SP
    
    acc_sp = ACC(sp_r, sp_c);
    acc_sp = acc_sp(:);
    max_acc_sp = max(max(acc_sp))
    [i_r_acc_sp, i_c_acc_sp] = find(acc_sp == max_acc_sp);
    
    % Sensitivity for SP
    sn_sp = SN(sp_r, sp_c);
    sn_sp = sn_sp(:);
    max_sn_sp = max(max(sn_sp))
    [i_r_sn_sp, i_c_sn_sp] = find(sn_sp == max_sn_sp);
    
    
    %% Find respective specificity and sensitivity for model with highest ACC
    
    acc = max(ACC);
    
    % Specificity for ACC
    sp_acc = SP(acc_r, acc_c);
    sp_acc = sp_acc(:);
    max_sp_acc = max(max(sp_acc));
    [i_r_sp_acc, i_c_sp_acc] = find(sp_acc == max_sp_acc);
    
    
    % Sensitivity for ACC
    sn_acc = SN(acc_r, acc_c);
    sn_acc = sn_acc(:);
    max_sn_acc = max(max(sn_acc));
    [i_r_sn_acc, i_c_sn_acc] = find(sn_acc == max_sn_acc);
    
    %% Find respective specificity and accuracy for model with highest SN
    
    sn = max(SN);
    
    % Specificity for SN
    sp_sn = SP(sn_r, sn_c);
    sp_sn = sp_sn(:);
    max_sp_sn = max(max(sp_sn));
    [i_r_sp_sn, i_c_sp_sn] = find(sp_sn == max_sp_sn);
    
    % Accuracy for SN
    acc_sn = ACC(sn_r, sn_c);
    acc_sn = acc_sn(:);
    max_acc_sn = max(max(acc_sn));
    [i_r_acc_sn, i_c_acc_sn] = find(acc_sn == max_acc_sn);
    
    % Store SP SN and ACC
    % ACC
%     acc_all = vertcat(acc', acc_sp, acc_sn);
%     sp_all = vertcat(sp_acc, sp', sp_sn);
%     sn_all = vertcat(sn_acc, sn_sp, sn');
    
%     results(jj).ACC = acc_all;
%     results(jj).SP = sp_all;
%     results(jj).SN = sn_all;
%     results(jj).CM = CM;
    
end

% save results_1 results
%% DMI
figure(1)
N = 2; % Number of colors to be used
% Use Brewer-map color scheme SET1
axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')
hold on
h1 = scatter(sp_acc, sn_acc,'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[0.5 0.5 0.5],...
              'LineWidth',0.5);
h3 = scatter(SP(accmax_r, accmax_c), SN(accmax_r, accmax_c),...
    'MarkerEdgeColor',[1 0 0],...
              'MarkerFaceColor',[1 0 0],...
              'LineWidth',1.5);

ax = gca;
% h.Color = 'black';
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
xlim([ 0 1]);
ylim([ 0 1]);
xlabel('Specificity','interpreter','latex')
ylabel('Sensitivity','interpreter','latex')
legend('', 'Max. Accuracy (0.9375)','location','southwest');
grid on; box on
% cleanfigure();
% matlab2tikz('filename',sprintf('SP_SN_scatter_1F.tex'));
%%
figure(2)
N = 2; % Number of colors to be used
% Use Brewer-map color scheme SET1
axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')
hold on
h1 = scatter(acc_sp, sn_sp,'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[0.5 0.5 0.5],...
              'LineWidth',0.5);
h3 = scatter(ACC(spmax_r, spmax_c), SN(spmax_r, spmax_c),...
    'MarkerEdgeColor',[1 0 0],...
              'MarkerFaceColor',[1 0 0],...
              'LineWidth',1.5);
ax = gca;
% h.Color = 'black';
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
xlim([ 0 1]);
ylim([ 0 1]);
xlabel('Accuracy','interpreter','latex')
ylabel('Sensitivity','interpreter','latex')
legend('', 'Max. Specificity (1.0)','location','northwest');
grid on; box on
% cleanfigure();
% matlab2tikz('filename',sprintf('SP_SN_scatter_1F.tex'));

%%
figure(3)
N = 2; % Number of colors to be used
% Use Brewer-map color scheme SET1
axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')
hold on
h1 = scatter(acc_sn, sp_sn,'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[0.5 0.5 0.5],...
              'LineWidth',0.5);
h3 = scatter(ACC(snmax_r, snmax_c), SP(snmax_r, snmax_c),...
    'MarkerEdgeColor',[1 0 0],...
              'MarkerFaceColor',[1 0 0],...
              'LineWidth',1.5);
ax = gca;
% h.Color = 'black';
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
xlim([ 0 1]);
ylim([ 0 1]);
xlabel('Accuracy','interpreter','latex')
ylabel('Specificity','interpreter','latex')
legend('', 'Max. Sensitivity (1.0)','location','southwest');
grid on; box on

