clear all; close all;clc

% First weed out all the rows with any zero values
% load clean_table

file = 'SAHS_cleaned_ETHN.xls';
SAHS_clean = readtable(file);

ft = table2array(SAHS_clean);

[r2,c2] = find(isnan(ft));
SAHS_clean(r2,:) = [];

ft = table2array(SAHS_clean(:,1:11));

[r1,c1] = find(ft == 0);
SAHS_clean(r1,:) = [];

% [data, hname] = xlsread(file, 'SAHSnDM');
% SAHS_clean = SAHS_features(:, 1:16);

glucose = table2array(SAHS_clean(:, 4:7))';
insulin = table2array(SAHS_clean(:, 8:11))';
% ethnicity = table2array(SAHS_clean(:, 2))';
% Categorize the initial data into four categories
% DMI   CVI  Category
%  0     0   -> 1
%  0     1   -> 2
%  1     0   -> 3
%  1     1   -> 4

dmi = table2array(SAHS_clean(:, 16))';
cvi = table2array(SAHS_clean(:, 17))';
Labels = zeros(size(cvi))';

for i = 1 : length(Labels)
    if dmi(i) == 0 && cvi(i) == 0
        Labels(i) = 1;
    elseif dmi(i) == 0 && cvi(i) == 1
        Labels(i) = 2;
    elseif dmi(i) == 1 && cvi(i) == 0
        Labels(i) = 3;
    elseif dmi(i) == 1 && cvi(i) == 1
        Labels(i) = 4;
    end
end



%% Calculate features

%%% Calculate slopes 0-30, 30-60, 60-120, 30-120, 0-120, 0-60

% Glucose
sl_glu_30_0 = (glucose(2,:) - glucose(1,:))'/30;
sl_glu_60_30 = (glucose(3,:) - glucose(2,:))'/30;
sl_glu_120_60 = (glucose(4,:) - glucose(3,:))'/60;

sl_glu_60_0 = (glucose(3,:) - glucose(1,:))'/60;
sl_glu_120_0 = (glucose(4,:) - glucose(1,:))'/120;

sl_glu_120_30 = (glucose(4,:) - glucose(2,:))'/90;


% Insulin

sl_ins_30_0 = (insulin(2,:) - insulin(1,:))'/30;
sl_ins_60_30 = (insulin(3,:) - insulin(2,:))'/30;
sl_ins_120_60 = (insulin(4,:) - insulin(3,:))'/60;

sl_ins_60_0 = (insulin(3,:) - insulin(1,:))'/60;
sl_ins_120_0 = (insulin(4,:) - insulin(1,:))'/120;

sl_ins_120_30 = (insulin(4,:) - insulin(2,:))'/90;


%%% Calculate T-half values

% Linear approximation
% th_gl_y1 = y1 + slope*( x - x1)

% Glucose
th_glu_15 = glucose(2,:)' + sl_glu_30_0*(30-15);
th_glu_45 = glucose(2,:)' + sl_glu_60_30*(45-30);
th_glu_90 = glucose(3,:)' + sl_glu_120_60*(90-60);

th_glu_30 = glucose(3,:)' + sl_glu_60_0*(30-60);
th_glu_60 = glucose(4,:)' + sl_glu_120_0*(60-120);
th_glu_75 = glucose(4,:)' + sl_glu_120_30*(75-120);

% Insulin
th_ins_15 = insulin(2,:)' + sl_ins_30_0*(30-15);
th_ins_45 = insulin(2,:)' + sl_ins_60_30*(45-30);
th_ins_90 = insulin(3,:)' + sl_ins_120_60*(90-60);

th_ins_30 = insulin(3,:)' + sl_ins_60_0*(30-60);
th_ins_60 = insulin(4,:)' + sl_ins_120_0*(60-120);
th_ins_75 = insulin(4,:)' + sl_ins_120_30*(75-120);


%%% Calculate Gradients 0-30, 30-60, 60-120, 30-120, 0-120, 0-60

% Glucose Gradient
gr_glu_30_0 = (glucose(2,:) - glucose(1,:))';
gr_glu_60_30 = (glucose(3,:) - glucose(2,:))';
gr_glu_120_60 = (glucose(4,:) - glucose(3,:))';

gr_glu_60_0 = (glucose(3,:) - glucose(1,:))';
gr_glu_120_0 = (glucose(4,:) - glucose(1,:))';

gr_glu_120_30 = (glucose(4,:) - glucose(2,:))';


% Insulin Gradient
gr_ins_30_0 = (insulin(2,:) - insulin(1,:))';
gr_ins_60_30 = (insulin(3,:) - insulin(2,:))';
gr_ins_120_60 = (insulin(4,:) - insulin(3,:))';

gr_ins_60_0 = (insulin(3,:) - insulin(1,:))';
gr_ins_120_0 = (insulin(4,:) - insulin(1,:))';

gr_ins_120_30 = (insulin(4,:) - insulin(2,:))';


% gr_glu = gradient(glucose);
% gr_ins = gradient(insulin);
% 
% gr_glu_30_0 = gr_glu(1,:)';
% gr_glu_60_30 = gr_glu(2,:)';
% gr_glu_120_60 = gr_glu(3,:)';
% 
% gr_ins_30_0 = gr_ins(1,:)';
% gr_ins_60_30 = gr_ins(2,:)';
% gr_ins_120_60 = gr_ins(3,:)';


% Calculate ar under the curve
ar_glu_0_30 = zeros(1,length(glucose));
ar_glu_0_60 = zeros(1,length(glucose));
ar_glu_0_120 = zeros(1,length(glucose));

ar_glu_30_60 = zeros(1,length(glucose));
ar_glu_30_120 = zeros(1,length(glucose));
ar_glu_60_120 = zeros(1,length(glucose));

ar_ins_0_30 = zeros(1,length(glucose));
ar_ins_0_60 = zeros(1,length(glucose));
ar_ins_0_120 = zeros(1,length(glucose));

ar_ins_30_60 = zeros(1,length(glucose));
ar_ins_30_120 = zeros(1,length(glucose));
ar_ins_60_120 = zeros(1,length(glucose));


for i = 1  : length(glucose)
    
    ar_glu_0_30(i) = trapz([glucose(1,(i)),glucose(2,(i))])'*30 ;
    ar_glu_0_60(i)  = trapz([glucose(1,(i)),glucose(3,(i))])'*60 ;
    ar_glu_0_120(i)  = trapz([glucose(1,(i)),glucose(4,(i))])'*120 ;
    
    ar_glu_30_60(i)  = trapz([glucose(2,(i)),glucose(2,(i))])'*30 ;
    ar_glu_30_120(i)  = trapz([glucose(2,(i)),glucose(4,(i))])'*90 ;
    ar_glu_60_120(i)  = trapz([glucose(3,(i)),glucose(4,(i))])'*60 ;
    
    ar_ins_0_30(i)  = trapz([insulin(1,(i)),insulin(2,(i))])'*30 ;
    ar_ins_0_60(i)  = trapz([insulin(1,(i)),insulin(3,(i))])'*60 ;
    ar_ins_0_120(i)  = trapz([insulin(1,(i)),insulin(4,(i))])'*120 ;
    
    ar_ins_30_60(i)  = trapz([insulin(2,(i)),insulin(2,(i))])'*30 ;
    ar_ins_30_120(i)  = trapz([insulin(2,(i)),insulin(4,(i))])'*90 ;
    ar_ins_60_120(i)  = trapz([insulin(3,(i)),insulin(4,(i))])'*60 ;
    
end

% Insulin Resistance (I/G)
IG_0_30 = sl_ins_30_0./sl_glu_30_0;
IG_0_60 = sl_ins_60_0./sl_glu_60_0;
IG_0_120 = sl_ins_120_0./sl_glu_120_0;
IG_30_60 = sl_ins_60_30./sl_glu_60_30;
IG_30_120 = sl_ins_120_30./sl_glu_120_30;
IG_60_120 = sl_ins_120_60./sl_glu_120_60;


% Matsuda Index
G0 = glucose(1,:)';
G30 = glucose(2,:)';
G60 = glucose(3,:)';
G120 = glucose(4,:)';

mean_G = [G30 G60 G120];

I0 = insulin(1,:)';
I30 = insulin(2,:)';
I60 = insulin(3,:)';
I120 = insulin(4,:)';

mean_I = [I30 I60 I120];

% Mat. Index
Mat_idx = 10000./(sqrt(G0.*I0.*mean(mean_G,2).*mean(mean_I,2)));

% IG * Matsuda
IGM_0_30 = IG_0_30.*Mat_idx;
IGM_0_60 = IG_0_60.*Mat_idx;
IGM_0_120 = IG_0_120.*Mat_idx;
IGM_30_60 = IG_30_60.*Mat_idx;
IGM_30_120 = IG_30_120.*Mat_idx;
IGM_60_120 = IG_60_120.*Mat_idx;

% HOMA_IR
HOMA_IR = G0.*I0/22.5;


% Feature List
% 1 - 6 Glucose Slopes
% 7 - 9 Glucose Gradients
% 10 - 15 Insulin Slopes
% 16 - 18 Insulin Gradients
% 19 - 24 Area under the glucose curve
% 25 - 30 Area under the insulin curve
% 31 - 36 Insulin Resistance (I/G) curves
% 37 - 42 Matsuda Index time the I/G curves
% 43 - HOMA-IR 
% 44 - Matsuda Index

% Create a feature set
Features = [ sl_glu_30_0, sl_glu_60_30, sl_glu_120_60, ...
    sl_glu_60_0, sl_glu_120_0, sl_glu_120_30, ...
    gr_glu_30_0, gr_glu_60_30, gr_glu_120_60, ...
    sl_ins_30_0, sl_ins_60_30, sl_ins_120_60, ...
    sl_ins_60_0, sl_ins_120_0, sl_ins_120_30,...
    gr_ins_30_0, gr_ins_60_30, gr_ins_120_60,...
    ar_glu_0_30', ar_glu_0_60', ar_glu_0_120',...
    ar_glu_30_60', ar_glu_30_120', ar_glu_60_120',...
    ar_ins_0_30', ar_ins_0_60', ar_ins_0_120',...
    ar_ins_30_60', ar_ins_30_120', ar_ins_60_120',...
    IG_0_30, IG_0_60, IG_0_120,...
    IG_30_60, IG_30_120, IG_60_120,...
    IGM_0_30, IGM_0_60, IGM_0_120,...
    IGM_30_60, IGM_30_120, IGM_60_120,...
    HOMA_IR, Mat_idx];

% ft = array2table(Features);

%% Assign column labels to the features table, ft
ft = table;

% Features from raw data
ft.AGE = table2array(SAHS_clean(:, 1));

ft.ETHN = table2array(SAHS_clean(:, 2));

ft.BMI = table2array(SAHS_clean(:, 3));

ft.PG0 = table2array(SAHS_clean(:, 4));
% 
ft.PG120 = table2array(SAHS_clean(:, 7));
% Slopes
    % Glucose
% ft.Sl_G_30_0 = sl_glu_30_0;
% ft.Sl_G_60_30 = sl_glu_60_30;
% ft.Sl_G_120_60 = sl_glu_120_60;
% ft.Sl_G_60_0 = sl_glu_60_0;
% ft.Sl_G_120_0 = sl_glu_120_0;
% ft.Sl_G_120_60 = sl_glu_120_60;

    % Insulin
% ft.Sl_I_30_0 = sl_ins_30_0;
% ft.Sl_I_60_30 = sl_ins_60_30;
% ft.Sl_I_120_60 = sl_ins_120_60;
% ft.Sl_I_60_0 = sl_ins_60_0;
% ft.Sl_I_120_0 = sl_ins_120_0;
% ft.Sl_I_120_60 = sl_ins_120_60;

% Gradients
    % Glucose
% ft.Gr_G_30_0 = gr_glu_30_0;
% ft.Gr_G_60_30 = gr_glu_60_30;
% ft.Gr_G_120_60 = gr_glu_120_60;
% ft.Gr_G_60_0 = gr_glu_60_0;
% ft.Gr_G_120_0 = gr_glu_120_0;
% ft.Gr_G_120_60 = gr_glu_120_60;

    % Insulin
% ft.Gr_I_30_0 = gr_ins_30_0;
% ft.Gr_I_60_30 = gr_ins_60_30;
% ft.Gr_I_120_60 = gr_ins_120_60;
% ft.Gr_I_60_0 = gr_ins_60_0;
% ft.Gr_I_120_0 = gr_ins_120_0;
% ft.Gr_I_120_60 = gr_ins_120_60;


% T-half values

    % Glucose
% ft.TH_G_15 = th_glu_15;
% ft.TH_G_30 = th_glu_30;
% ft.TH_G_45 = th_glu_45;
% ft.TH_G_60 = th_glu_60;
% ft.TH_G_75 = th_glu_75;
% ft.TH_G_90 = th_glu_90;

    % Insulin
% ft.TH_I_15 = th_ins_15;
% ft.TH_I_30 = th_ins_30;
% ft.TH_I_45 = th_ins_45;
% ft.TH_I_60 = th_ins_60;
% ft.TH_I_75 = th_ins_75;
% ft.TH_I_90 = th_ins_90;
    

% Area under the curve
    % Glucose
% ft.A_G_0_30 = ar_glu_0_30';
% ft.A_G_0_60 = ar_glu_0_60';
ft.A_G_0_120 = ar_glu_0_120';

% ft.A_G_30_60 = ar_glu_30_60';
% ft.A_G_30_120 = ar_glu_30_120';
% ft.A_G_60_120 = ar_glu_60_120';

    % Insulin
% ft.A_I_0_30 = ar_ins_0_30';
% ft.A_I_0_60 = ar_ins_0_60';
% ft.A_I_0_120 = ar_ins_0_120';

% ft.A_I_30_60 = ar_ins_30_60';
% ft.A_I_30_120 = ar_ins_30_120';
% ft.A_I_60_120 = ar_ins_60_120';

% Insulin resistance

ft.IG_0_30 = IG_0_30;
% ft.IG_0_60 = IG_0_60;
% ft.IG_0_120 = IG_0_120;
% ft.IG_30_60 = IG_30_60;
% ft.IG_30_120 = IG_30_120;
% ft.IG_60_120 = IG_60_120;

% Insulin resistance x Matsuda Index

ft.IGM_0_30 = IGM_0_30;
% ft.IGM_0_60 = IGM_0_60;
ft.IGM_0_120 = IGM_0_120;
% ft.IGM_30_60 = IGM_30_60;
% ft.IGM_30_120 = IGM_30_120;
% ft.IGM_60_120 = IGM_60_120;

% Matsuda Index
ft.Matsuda = Mat_idx;

% HOMA-IR
% ft.HOMAIR = HOMA_IR;


lb = array2table(Labels);
SAHS_features = [SAHS_clean ft lb];

% Labels = cell(Labels');
% save features_all
% save clean_table.mat SAHS_features SAHS_clean ft Labels
save data_plus_features_AbdulGhani.mat SAHS_features SAHS_clean ft Labels