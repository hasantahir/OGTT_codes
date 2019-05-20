% Extract Values from load('Validation_results_AbdulGhani.mat')
%Last Edit: Marelyn Rios on July 10, 2018

load('Validation_results_AbdulGhani.mat')
% all_acc = struct2cell(Validation_results.max_acc);

for i = 1: size(Validation_results,2)
    for j = 1: size(Validation_results,2)
        ACC(i,j) = Validation_results(i).max_acc(j);
        SEN(i,j) = Validation_results(i).sn_max_acc(j);
        Names{i,j} = Validation_results(i).features{j};
    end 
end 

for k =1:size(ACC,1)
    AVG_ACC(k) = mean(ACC(k,:)); 
    AVG_SEN(k) = mean(SEN(k,:));

end 

Results = table(AVG_ACC', AVG_SEN');
Results.Properties.VariableNames{1} = 'RunACC';
Results.Properties.VariableNames{2} = 'RunSEN';

