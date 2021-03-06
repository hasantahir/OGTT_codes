clear all
% load M2_Train_2Fs.mat
load M_train.mat

% First select the one with best sensitivity
M2 = M_train;
% find the size of all models object

for NbF = 1 : 2
    len = size(M2(NbF).all_cv_models,2);
    
    all_cv_models = M2(NbF).all_cv_models;
    
    % for each feature, find the best model, specifity, sensitivity,
    % accuracy-wise
    for i = 1 : len
        temp = all_cv_models(i).models;
        for k = 1 : 10
            model = cell2mat(temp(k)); % convert in order to access cell properties
            SP(i,k) = model.Specificity;
            SN(i,k) = model.Sensitivity;
            ACC(i,k) = model.LastCorrectRate;
        end
    end

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
    % Since we take the transpose, so order reversed
    CP = all_cv_models(accmax_r).models;
    CP = cell2mat(CP(accmax_c));
    CM = CP.CountingMatrix;
    
    
    
    %% Find respective accuracy and sensitivity for model with highest SP
    
    sp = max(SP);
    
    % Accuracy for SP
    
    acc_sp = ACC(sp_r, sp_c);
    acc_sp = acc_sp(:);
    max_acc_sp = max(max(acc_sp));
    [i_r_acc_sp, i_c_acc_sp] = find(acc_sp == max_acc_sp);
    
    % Sensitivity for SP
    sn_sp = SN(sp_r, sp_c);
    sn_sp = sn_sp(:);
    max_sn_sp = max(max(sn_sp));
    [i_r_sn_sp, i_c_sn_sp] = find(sn_sp == max_sn_sp);
    
    % Accuaracy and Sensitivity at maximum specificity
    ACC_max_SP = ACC(spmax_r, spmax_c)
    SN_max_SP = SN(spmax_r, spmax_c)
    
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
    
    % Sensitivity and Specificity at maximum accuracy
    SP_max_ACC = SP(accmax_r, accmax_c)
    SN_max_ACC = SN(accmax_r, accmax_c)
    
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
    
    
    % Accuaracy and Specificity at maximum  Sensitivity
    ACC_max_SN = ACC(snmax_r, snmax_c)
    SP_max_SN = SP(snmax_r, snmax_c)
    
    
    CM, accmax, spmax, snmax
    % Store SP SN and ACC
    % ACC
    Results.max_acc(NbF) = accmax;
    Results.max_acc_idx_r(NbF) = accmax_r;
    Results.max_acc_idx_c(NbF) = accmax_c;
    Results.sp_max_acc(NbF) = SP_max_ACC;
    Results.sn_max_acc(NbF) = SN_max_ACC;
    
    Results.max_sp(NbF) = spmax;
    Results.max_sp_idx_r(NbF) = spmax_r;
    Results.max_sp_idx_c(NbF) = spmax_c;
    Results.acc_max_sp(NbF) = ACC_max_SP;
    Results.sn_max_sp(NbF) = SN_max_SP;
    
    Results.max_sn(NbF) = snmax;
    Results.max_sn_idx_r(NbF) = snmax_r;
    Results.max_sn_idx_c(NbF) = snmax_c;
    Results.acc_max_sn(NbF) = ACC_max_SN;
    Results.sp_max_sn(NbF) = SP_max_SN;
    
    Results.CM{NbF} = CM;
    
end


save train_results Results
% scatter3(acc_all, sp_all, sn_all)
% plot(sp_acc, sn_acc,'o')
% hold on
% plot(SP(accmax_r, accmax_c), SN(accmax_r, accmax_c), 'x')

%% DMI
% figure(1)
% N = 2; % Number of colors to be used
% % Use Brewer-map color scheme SET1
% axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')
% hold on
% h1 = scatter(sp_acc, sn_acc,'MarkerEdgeColor',[0 0 0],...
%               'MarkerFaceColor',[0.5 0.5 0.5],...
%               'LineWidth',0.5);
% h3 = scatter(SP(accmax_r, accmax_c), SN(accmax_r, accmax_c),...
%     'MarkerEdgeColor',[1 0 0],...
%               'MarkerFaceColor',[1 0 0],...
%               'LineWidth',1.5);
%
% ax = gca;
% % h.Color = 'black';
% set(gcf,'Color','white'); % Set background color to white
% set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
% xlim([ 0 1]);
% ylim([ 0 1]);
% xlabel('Specificity','interpreter','latex')
% ylabel('Sensitivity','interpreter','latex')
% legend('', 'Max. Accuracy (0.9375)','location','southwest');
% grid on; box on
% % cleanfigure();
% matlab2tikz('filename',sprintf('SP_SN_scatter_1F.tex'));
% %%
% figure(2)
% N = 2; % Number of colors to be used
% % Use Brewer-map color scheme SET1
% axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')
% hold on
% h1 = scatter(acc_sp, sn_sp,'MarkerEdgeColor',[0 0 0],...
%               'MarkerFaceColor',[0.5 0.5 0.5],...
%               'LineWidth',0.5);
% h3 = scatter(ACC(spmax_r, spmax_c), SN(spmax_r, spmax_c),...
%     'MarkerEdgeColor',[1 0 0],...
%               'MarkerFaceColor',[1 0 0],...
%               'LineWidth',1.5);
% ax = gca;
% % h.Color = 'black';
% set(gcf,'Color','white'); % Set background color to white
% set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
% xlim([ 0 1]);
% ylim([ 0 1]);
% xlabel('Accuracy','interpreter','latex')
% ylabel('Sensitivity','interpreter','latex')
% legend('', 'Max. Specificity (1.0)','location','northwest');
% grid on; box on
% % cleanfigure();
% % matlab2tikz('filename',sprintf('SP_SN_scatter_1F.tex'));
%
% %%
% figure(3)
% N = 2; % Number of colors to be used
% % Use Brewer-map color scheme SET1
% axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')
% hold on
% h1 = scatter(acc_sn, sp_sn,'MarkerEdgeColor',[0 0 0],...
%               'MarkerFaceColor',[0.5 0.5 0.5],...
%               'LineWidth',0.5);
% h3 = scatter(ACC(snmax_r, snmax_c), SP(snmax_r, snmax_c),...
%     'MarkerEdgeColor',[1 0 0],...
%               'MarkerFaceColor',[1 0 0],...
%               'LineWidth',1.5);
% ax = gca;
% % h.Color = 'black';
% set(gcf,'Color','white'); % Set background color to white
% set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
% xlim([ 0 1]);
% ylim([ 0 1]);
% xlabel('Accuracy','interpreter','latex')
% ylabel('Specificity','interpreter','latex')
% legend('', 'Max. Sensitivity (1.0)','location','southwest');
% grid on; box on
%
%
%
%
% N = 10;
% axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')
% plot(SP, SN,'o')
% ax = gca;
% % h.Color = 'black';
% set(gcf,'Color','white'); % Set background color to white
% set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
% xlim([ 0 1]);
% ylim([ 0 1]);
% xlabel('Specificity','interpreter','latex')
% ylabel('Sensitivity','interpreter','latex')
% % legend('', 'Max. Accuracy (0.9375)','location','southwest');
% grid on; box on