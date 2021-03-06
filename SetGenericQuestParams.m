function params = SetGenericQuestParams(dims)






params.col_tree.eigs_num = 12;
params.row_tree.eigs_num = 12;


params.n_iters = 1;

params.row_emd.beta = 0;
params.row_emd.alpha = 0;
params.row_emd.eps = 1;

params.col_emd.beta = 0;
params.col_emd.alpha = 0;
params.col_emd.eps = 1;
params.data.to_normalize = false;
params.col_tree.embedded = false;
params.col_tree.threshold = 0;
params.col_tree.k = 2;
params.col_tree.verbose = 0;
params.col_tree.min_cluster = 20;

params.row_tree.embedded = false;
params.row_tree.threshold = 0;
params.row_tree.k = 2;
params.row_tree.verbose = 0;
params.row_tree.min_cluster = 20;
params.col_tree.runOnEmbdding = true;
params.row_tree.runOnEmbdding = true;
params.col_tree.treeDepth = Inf;
params.row_tree.treeDepth = Inf;
params.verbose=2;
params.col_tree.buildTreeFun = @BuildTreeViaPCAclustering;
params.row_tree.buildTreeFun = @BuildTreeViaPCAclustering;

params.init_aff_row.metric = 'euc';
params.init_aff_row.knn = 5;
params.init_aff_row.eps = 1;
params.init_aff_row.thresh = 0;

params.init_aff_col.metric = 'euc';
params.init_aff_col.knn = 5;
params.init_aff_col.eps = 1;
params.init_aff_col.thresh = 0;
switch dims
    case 2
        
        params.init_aff_col.initAffineFun= @CalcInitAff;
        params.init_aff_row.initAffineFun = @CalcInitAff;
        params.init_aff_trial.initAffineFun = @CalcInitAff;
        
        params.col_tree.CalcAffFun = @CalcEmdAff;
        params.row_tree.CalcAffFun = @CalcEmdAff;
    case 3
        params.trial_tree.treeDepth = Inf;
        params.trial_tree.runOnEmbdding = false;
        params.init_aff_col.initAffineFun= @CalcInitAff3D;
        params.init_aff_row.initAffineFun = @CalcInitAff3D;
        params.init_aff_trial.initAffineFun = @CalcInitAff3D;
        params.col_tree.CalcAffFun = @CalcEmdAff3D;
        params.row_tree.CalcAffFun = @CalcEmdAff3D;
        params.trial_tree.CalcAffFun = @CalcEmdAff3D;
        
        
        params.trial_tree.buildTreeFun = @BuildTreeViaPCAclustering;
        
        
        
        params.trial_tree.embedded = false;
        params.trial_tree.threshold = 0;
        params.trial_tree.k = 2;
        params.trial_tree.verbose = 0;
        params.trial_tree.min_cluster = 20;
        params.init_aff_trial.metric = 'euc';
        params.init_aff_trial.knn = 5;
        params.init_aff_trial.eps = 1;
        params.init_aff_trial.thresh = 0;
        params.trial_tree.eigs_num = 12;
    otherwise
        error('Dims must be 2 or 3');
end





params.trial_emd.beta = 0;
params.trial_emd.alpha = 0;
params.trial_emd.eps = 1;
