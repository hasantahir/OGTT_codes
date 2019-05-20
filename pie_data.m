close all;clear

X = [94/1492, 1360/1492 , 38/1492];
explode = [0 1 2 ];
labels = {'Validation','Training', 'Remaining'};
N = 3; % Number of colors to be used
% % Use Brewer-map color scheme SET1
axes('ColorOrder',brewermap(N,'Set1'),'NextPlot','replacechildren')
pie(X, explode, labels)


ax = gca;
% ax.XTick = group;
% ax.XTickLabel = {'PG120','AuC-G_{60-120}','AuC-G_{0-120}','AuC-G_{30-120}',...
%     '\Delta G/\Delta t _{0-60}','\Delta G/\Delta t _{0-120}',...
%     '\Delta G/\Delta t _{30-60}','\Delta G/\Delta t_{60-120}'};
% ax.XTickLabelRotation = 270;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
matlab2tikz('filename',sprintf('pie.tex'));
hgexport(gcf, 'pie.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
savefig('pie.fig')
print(gcf,'pie.png','-dpng','-r1000');