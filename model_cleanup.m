filenames = {
    'M_all_AbdulGhani1'
    'M_all_AbdulGhani2'
    'M_all_AbdulGhani3'
    'M_all_AbdulGhani4'
    'M_all_AbdulGhani5'
    'M_all_AbdulGhani6'
    'M_all_AbdulGhani7'
    'M_all_AbdulGhani8'
    'M_all_AbdulGhani10'
    };

for iter = 1 : size(filenames,1)
    
    
    load(filenames{iter}, 'M_all')
    
    disp('----------------------------------------')
    [iter]
    
    M_all(6).svm_structs(211:252) = [];
    M_all(6).pred_models(211:252) = [];
    M_all(6).val_models(211:252) = [];
    
    M_all(7).svm_structs(121:252) = [];
    M_all(7).pred_models(121:252) = [];
    M_all(7).val_models(121:252) = [];
    
    M_all(8).pred_models(46:252) = [];
    M_all(8).svm_structs(46:252) = [];
    M_all(8).val_models(46:252) = [];
    
    M_all(9).pred_models(11:252) = [];
    M_all(9).svm_structs(11:252) = [];
    M_all(9).val_models(11:252) = [];
    
    M_all(10).pred_models(2:252) = [];
    M_all(10).svm_structs(2:252) = [];
    M_all(10).val_models(2:252) = [];
    
    
    save(filenames{iter}, 'M_all')
    
end