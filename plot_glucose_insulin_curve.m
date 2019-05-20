openfig('Fig1_1.fig')

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
xlim([ 0 4]);
xticks([0 1 2 4])
xticklabels({'0','30','60', '120'})


% ylim([ 0.67 1]);
xlabel('Minutes','interpreter','latex')
ylabel('Glucose \SI{}{\milli\gram\per\deci\liter}','interpreter','latex')
legend('Healthy', 'Diabetic','location','southeast');
grid on; box on
matlab2tikz('filename',sprintf('Glucose_curve.tex'));

hgexport(gcf, 'Glucose_curve.jpg', hgexport('factorystyle'), 'Format', 'jpeg');


%%

openfig('Fig1_2.fig')

ax = gca;
set(gcf,'Color','white'); % Set background color to white
set (gca,'FontName','times new roman') % Set axes fonts to Times New Roman
xlim([ 0 4]);
xticks([0 1 2 4])
xticklabels({'0','30','60', '120'})


% ylim([ 0.67 1]);
xlabel('Minutes','interpreter','latex')
ylabel('Insulin \SI{}{\milli\gram\per\deci\liter}','interpreter','latex')
legend('Healthy', 'Diabetic','location','southeast');
grid on; box on
matlab2tikz('filename',sprintf('Insulin_curve.tex'));

hgexport(gcf, 'Insulin_curve.jpg', hgexport('factorystyle'), 'Format', 'jpeg');