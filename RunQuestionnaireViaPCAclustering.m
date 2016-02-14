function [ row_tree, col_tree ] = RunQuestionnaireViaPCAclustering( params, data )
% Runs questionnaire algorithm using trees built by PCA clustering
% Author: Hadas Benisty
% 14.2.2016
%
% Inputs:
%     params - struct array with all user parameters
%     data - M-by-N matrix whose columns are N points in R^M (optional)
%
% Outputs:
%     row_tree, col_tree - the resulting partition trees, given as cells of
%         struct arrays
%--------------------------------------------------------------------------

if params.data.to_normalize,
    data = NormalizeData(data, params.data);
    figure, imagesc(data), colormap gray, axis on, title('Normalized Data'), colorbar
end
col_init_aff = CalcInitAff(data, params.init_aff_row);
[vecs, vals] = CalcEigs(col_init_aff, params.col_tree.eigs_num); 
col_tree = BuildTreeViaPCAclustering(vecs * vals, params.col_tree);
figure;

for ii = 1:params.n_iters,
    row_dual_aff = CalcEmdAff(data.', col_tree, params.row_emd);    
    [vecs, vals] = CalcEigs(row_dual_aff, params.row_tree.eigs_num); 
    row_tree = BuildTreeViaPCAclustering(vecs * vals, params.row_tree);
    

    col_dual_aff = CalcEmdAff(data, row_tree, params.col_emd);
    [vecs, vals] = CalcEigs(col_dual_aff, params.col_tree.eigs_num); 
    col_tree = BuildTreeViaPCAclustering(vecs * vals, params.col_tree);
    subplot(2,1,1);
    
    plotTreeWithColors(row_tree, 1:size(data, 1));
    title('2D - Row Tree');
    
    subplot(2,1,2);
    plotTreeWithColors(col_tree, 1:size(data, 2));
    title('2D - Col Tree');
    drawnow;
    
end
end


