function params = SetQuestPCAclusteringParams


params.data.to_normalize = false;
params.col_tree.embedded = false;
params.col_tree.threshold = 0;
params.col_tree.k = 2;
params.col_tree.verbose = 0;
params.col_tree.min_cluster = 16;

params.row_tree.embedded = false;
params.row_tree.threshold = 0;
params.row_tree.k = 2;
params.row_tree.verbose = 0;
params.row_tree.min_cluster = 16;

params.col_aff_row.metric = 'euc';
params.col_aff_row.knn = 5;
params.col_aff_row.eps = 1;

params.init_aff_row.metric = 'euc';
params.init_aff_row.knn = 5;
params.init_aff_row.eps = 1;


params.col_tree.eigs_num = 12;
params.row_tree.eigs_num = 12;

params.n_iters = 2;

params.row_emd.beta = 0;
params.row_emd.alpha = 0;
params.row_emd.eps = 1;

params.col_emd.beta = 0;
params.col_emd.alpha = 0;
params.col_emd.eps = 1;
