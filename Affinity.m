function A = Affinity(data,threshold)

[sizeRows,sizeCols] = size(data);
% cosine similarity with thresholding
innerProduct = data'*data;
data       = data.^2;
normIJ     = data'*ones(sizeRows,sizeCols);
normJI     = ones(sizeCols,sizeRows)*data;
A          = innerProduct./sqrt(normIJ.*normJI);
A(A < threshold) = 0; 


