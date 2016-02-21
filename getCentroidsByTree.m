function [meanMat, allMat] = getCentroidsByTree(tree, data, labels, newLabels)

meanMat=[];allMat=[];
folders = unique(tree.clustering);
for ci = 1:length(folders)
    inds2folder = find(tree.clustering == folders(ci));
    currLabels = labels(inds2folder);
    loc = findStrLocInCellArray(newLabels, currLabels);
    meanMat(ci, :) = mean(mean(permute(data(loc(loc~=0), :, :), [2 3 1]),2), 3);
    allMat{ci} = permute(mean(permute(data(loc(loc~=0), :, :), [2 3 1]),2), [3 1 2]);
end
