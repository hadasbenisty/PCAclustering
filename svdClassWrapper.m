function [clustering, redundant] = svdClassWrapper(data, params)

redundant = false;
dataForClustering{1} = permute(data, [2 3 1]);
embedded = false;
[clustering,pc,affinity,eigVals] = svdClass(dataForClustering,params.k,embedded,params.threshold,'',false);
clustering = transpose(clustering(:));