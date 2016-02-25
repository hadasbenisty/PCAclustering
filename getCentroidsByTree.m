function [meanMat, allMat, meanMatAlltrials] = getCentroidsByTree(tree, data, labels, newLabels)

meanMat=[];allMat=[];meanMatAlltrials=[];
folders = unique(tree.clustering);
for ci = 1:length(folders)
    inds2folder = find(tree.clustering == folders(ci));
    currLabels = labels(inds2folder);
    loc = findStrLocInCellArray(newLabels, currLabels);
    meanMat(ci, :) = mean(mean(permute(data(loc(loc~=0), :, :), [2 3 1]),2), 3);
    allMat{ci} = permute(mean(permute(data(loc(loc~=0), :, :), [2 3 1]),2), [3 1 2]);
    meanMatAlltrials = cat(1, meanMatAlltrials, permute(mean(permute(data(loc(loc~=0), :, :), [2 3 1]),3), [3 1 2]));
end
