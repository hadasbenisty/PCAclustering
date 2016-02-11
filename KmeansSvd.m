function [class,V,centroids] = KmeansSvd(data,k,useFit,plotFlag,dimString)
% KmeansSvd clasify the data into k (approx.) clusters via PCA (based on the papers:
%           "K-means Clustering via Principal Component Analysis" [Ding & He]
%==========================================================================
% AUTHOR        Almog Lahav
% INSTITUTION   Technion
% DATE          10th February 2016
%
%
% INPUTS
%   data            - 2D matrix. n Columns - samples, m Rows - features.
%   k               - number of clusters.
%   useFit          - use the matlab function fit to find minima in the 
%                     crossing of the affinity matrix 
%   dimString       - title for plots. relavant only if plotFlagKmeans == false.
%   plotFlag        - plot connectivity matrix and its crossing.
%
% OUTPUTS
%   class           - a vector nx1, contains the values 1 to k, according to
%                     the clustering results.
%   V               - nxn matrix contains all the principal components.
%   affinity        - the affinity used for the diffusion map.
%   centroids       - k centroids of the clusters.
%==========================================================================

% options.tol = 1e-1;
% [U,S,V] = svds(cov(data),k,'L',options);
data = data - repmat(mean(data,2),1,size(data,2));
[U,S,V] = svd(cov(data));
% [U,S,V] = svd(data);

% compute connectivity C matrix from the eigen vectors
% C = V*V';
C = V(:,1:k)*V(:,1:k)';
[cCols,cRows] = meshgrid(diag(C),diag(C));
P = C./(sqrt(cCols.*cRows));
C(P < 0.5) = 0;

% Clustering based on the paper: "Linearized Cluster Assignment via Spectral Ordering"

% Compute J2 ordering, here we will call this order: "index"
D = diag(sum(C,2));
[Q,E] = eig((D^(-0.5))*C*(D^(-0.5)));
q = (D^-0.5)*Q(:,2);
% q = circshift(q,[round((length(q))/2) 0]);
[val,index] = sort(q);
% index = circshift(index,round((length(index))/2));

if(plotFlag)
    figure;
    imshow(C(index,index)*1000);
    title(strcat('Connectivity Matrix - ',dimString))
end

% Compute the crossing, here we will call it: "cross"
subAntiDiags = spdiags(rot90(C(index,index)+eps));
rhoHalfPlus  = [0 mean(subAntiDiags(:,2:2:end))];
rhoHalfMinus = [mean(subAntiDiags(:,2:2:end)) 0];
rho          = mean(subAntiDiags(:,1:2:end));
cross        = rho/2 + rhoHalfPlus/4 +rhoHalfMinus/4;

% Find K-1 minima in the crossing, 2 options
% 1. By fitting the crossing to fourier series
% 2. By using round(1.6*k) first furrier coefficients
minStart = 5;
if(useFit)
    crossFit = feval(fit((1:length(cross))',cross','fourier8'),1:length(cross));
else
    crossFreq = fft(cross);
%     crossFreq(5*round(length(cross)/k):end)=0; % LPF
    crossFreq(round(k*1.6):end)=0; % LPF
    crossFit = abs(ifft(crossFreq))';
end
DataInv = 1.01*max(crossFit) - crossFit;
[Minima,MinIdx] = findpeaks(double(DataInv(minStart:end)));
MinIdx = MinIdx + minStart - 1;

if(plotFlag)
    figure;
    plot(crossFit-mean(crossFit),'r')
    hold on
    plot(MinIdx,crossFit(MinIdx)-mean(crossFit),'or')
    plot(cross-mean(cross),'b')
    title(strcat('Crossing - ',dimString))
end

% Clasifying based on the crossing minima
class = zeros(size(data,2),1);
MinIdx = [1 ; MinIdx ; size(data,2)];
for i=1:length(MinIdx)-1
    class(index(MinIdx(i):MinIdx(i+1))) = i;
    centroids(:,i) = mean(data(:,index(MinIdx(i):MinIdx(i+1))),2);
end

% [U,S,V] = svd(cov(centroids));
% [val,indexCenter] = sort(V(:,2));
% 
% for i=1:length(MinIdx)-1
%     class(index(MinIdx(i):MinIdx(i+1))) = indexCenter(i);
% end

