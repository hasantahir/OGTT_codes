k=10;

cvFolds = crossvalind('Kfold', label, k);   %# get indices of 10-fold CV
cp = classperf(label);                      %# init performance tracker

meas = Data;
groups = label;
for i = 1:k                                  %# for each fold
    testIdx = (cvFolds == i);                %# get indices of test instances
    trainIdx = ~testIdx;                     %# get indices training instances

    %# train an SVM model over training instances
    svmModel = svmtrain(meas(trainIdx,:), groups(trainIdx), ...
                 'Autoscale',true, 'Showplot',false, 'Method','QP', ...
                 'BoxConstraint',2e-1, 'Kernel_Function','rbf', 'RBF_Sigma',1);

    %# test using test instances
    pred = svmclassify(svmModel, meas(testIdx,:), 'Showplot',false);

    %# evaluate and update performance object
    cp = classperf(cp, pred, testIdx);
    cp.CorrectRate
    cp.CountingMatrix
end

%# get accuracy
cp.CorrectRate

%# get confusion matrix
%# columns:actual, rows:predicted, last-row: unclassified instances
cp.CountingMatrix