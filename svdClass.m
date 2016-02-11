function [class,pc,affinity,eigVals] = svdClass(data,k,embedded,threshold,title,plotFlagKmeans)
% svdClass  wrap the function KmeansSvd
%==========================================================================
% AUTHOR        Almog Lahav
% INSTITUTION   Technion
% DATE          10th February 2016
%
%
% INPUTS
%   data            - a struct of N (unlimited) 3D matrices with fix size n in the third 
%                     dimension. The clustering is aplied on the 3rd dimension, i.e. one sample 
%                     is a vector contains the entries of a sub matrix
%                     in the 3rd dimension. If N>1 the entries of N
%                     sub matrices are concatenated.
%                     constraint: the size of the 3rd dimenssion of all 
%                     3D matrices in data, has to be the same (n).
%   k               - number of clusters.
%   embbeded        - use the data in the embedded space using diffusion map (true),
%                     or the original data (false)
%   threshold       - relevant only if embedded == true. If the affinity
%                     of two samples is under this threshold it get 0.
%   title           - relavant only if plotFlagKmeans == false
%   plotFlagKmeans  - plot connectivity matrix and its crossing.
%
% OUTPUTS
%   class           - a vector nx1, contains the values 1 to k, according to
%                     the clustering results. n is the number of samples
%                     (3rd dimension size).
%   pc              - nxn contains all the principal components.
%   affinity        - the affinity used for the diffusion map.
%   eigVals         - the first 3 eigen values used for the diffusion map.
%==========================================================================

% concatenate entries of sub-mtrices in the 3rd dimension
hirarchNum = length(data);
samplesLength = zeros(1,hirarchNum);

for i=1:hirarchNum
    samplesLength(i) = numel(data{i})/size(data{i},3);
    samplesNum = size(data{i},3);
    dataUnfoldHirarch{i} = reshape(data{i},[samplesLength(i) samplesNum]);
end

start=1;
dataUnfold = zeros(sum(samplesLength),samplesNum);
for i=1:hirarchNum
    dataUnfold(start:samplesLength(i)+start-1,:) = dataUnfoldHirarch{i};
    start = start + samplesLength(i);
end

% create affinity matrix and compute the embedding
affinity  = Affinity(dataUnfold,threshold);
symAffinity = SymetricAff(affinity);
% options.tol = 1e-1;% tolerance for svd
% [initRowsVecotrs,Srows,V] = svds(symAffinityRows,k+1,'L',options);
[leftVecotrs,S,V] = svd(symAffinity);
eigVals    = max(S(:,2:4));
diffTime = 1.0/(1.0 - eigVals(1));
eigVals = repmat(max(S(:,2:k+1)),samplesNum,1);

switch embedded
    
    case false
        dataForSvd = dataUnfold;   
    case true
        dataForSvd = (leftVecotrs(:,2:k+1).*(eigVals.^diffTime))';
end

% if(plotFlagKmeans)
%     showEmbedding(leftVecotrs(:,2:4),eigVals,color_mat,strcat('Embedded Space - ',title));
% end

% apply the k-means using SVD
useFit = false;
[class,pc] = KmeansSvd(dataForSvd,k,useFit,plotFlagKmeans,title);