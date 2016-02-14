function tree = BuildTreeViaPCAclustering(data, params)


%initialize root (top-most level):
N = size(data, 1);
rev_tree{1}.folder_count = 1;
rev_tree{1}.folder_sizes = N;
rev_tree{1}.clustering = ones(1, N);
rev_tree{1}.super_folders = [];

[clustering,pc,affinity,eigVals] = svdClass({permute(data, [2 3 1])}, params.k, params.embedded, params.threshold, ...
    ['Building a tree level: ' num2str(1)],params.verbose);
rev_tree{2}.folder_count = params.k;
rev_tree{2}.clustering = clustering;
for ki = 1:params.k
    rev_tree{2}.folder_sizes(ki) = sum(rev_tree{2}.clustering == ki);
end
rev_tree{2}.super_folders = [1 1];
currLevel = 3;
MAX_ITERS = 1e6;
for iter = 1:MAX_ITERS
    clusters = unique(rev_tree{currLevel-1}.clustering);
    maxCluster = 0;
    for ci = 1:length(clusters)
        curr_cluster_inds2data = find(rev_tree{currLevel-1}.clustering == clusters(ci));
        supFolders(curr_cluster_inds2data) = ci;
        if numel(curr_cluster_inds2data) > params.min_cluster
            if params.verbose > 1
            disp(['Tree level ' num2str(currLevel) ' cluster num ' num2str(ci)]);
            end
            [clustering,pc,affinity,eigVals] = svdClass({permute(data(curr_cluster_inds2data, :), [2 3 1])}, params.k, params.embedded, params.threshold, ...
                ['Building a tree level: ' num2str(currLevel)],params.verbose);
            rev_tree{currLevel}.clustering(curr_cluster_inds2data) = clustering + maxCluster;
            
            if max(clustering) == 1
                finished(ci) = 1;
            else
                finished(ci) = 0;
            end
        else
           finished(ci) = 1;
           rev_tree{currLevel}.clustering(curr_cluster_inds2data) = maxCluster + 1;
        end
        maxCluster = max(rev_tree{currLevel}.clustering);
    end
    rev_tree{currLevel}.super_folders = [];
    for ci = 1:length(finished)
       if  finished(ci)
           rev_tree{currLevel}.super_folders = [rev_tree{currLevel}.super_folders ci];
       else
           rev_tree{currLevel}.super_folders = [rev_tree{currLevel}.super_folders ci ci];
       end
    end
    rev_tree{currLevel}.folder_count = numel(unique(rev_tree{currLevel}.clustering));
    for ki = 1:rev_tree{currLevel}.folder_count
        rev_tree{currLevel}.folder_sizes(ki) = sum(rev_tree{currLevel}.clustering == ki);
    end
    if all(finished)
        break;
    end
    currLevel = currLevel + 1;
end
% last level - each data point is a leaf


rev_tree{currLevel}.folder_count = N;
rev_tree{currLevel}.folder_sizes = ones(1,N);
rev_tree{currLevel}.clustering = 1:N;
rev_tree{currLevel}.super_folders = rev_tree{currLevel-1}.clustering;

tree = fliplr(rev_tree);


