function clustering = svdClassWrapper(data, params, inds)


clustering = svdClass({permute(data(inds, inds), [2 3 1])}, params.splitsNum, false, 0, ...
    ['Building a tree level: ' num2str(1)],params.verbose > 1);
