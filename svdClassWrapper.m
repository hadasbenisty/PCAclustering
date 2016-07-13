function clustering = svdClassWrapper(data, splitsNum, params)


clustering = svdClass({permute(data, [2 3 1])}, splitsNum, false, 0, ...
    ['Building a tree level: ' num2str(1)],0);
