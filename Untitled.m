len = size(M_all.models,2)
temp = M_all.models.mdl;
for k = 1 : 10
    model = cell2mat(temp(k)); % convert in order to access cell properties
    SP(k) = model.Specificity;
    SN(k) = model.Sensitivity;
    ACC(k) = model.LastCorrectRate;
end

[acc_r, acc_c] = find(ACC == (max(ACC)));
max(ACC), max(SP), max(SN)