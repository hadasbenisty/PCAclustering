clc;
clear all;
close all;

%%%%%%  k-means via SVD  - test for th function KmeansSvd %%%%%%
% creat 3 3D gaussians
k = 3;
useFit = true;
plotFlag = true;
nSamples = 100;
MU1 = [0 5 10];
% SIGMA1 = [2.5 2; 2 2];
SIGMA1 = [2 0 0; 0 2 0;0 0 2];
MU2 = [10 0 0];
SIGMA2 = [1 0 0; 0 1 0;0 0 1];
MU3 = [0 10 0];
SIGMA3 = [1 0 0; 0 1 0; 0 0 1];
MU4 = [5 20 0];
SIGMA4 = [1 0 0; 0 1 0; 0 0 1];
data = [mvnrnd(MU1,SIGMA1,nSamples) ;mvnrnd(MU2,SIGMA2,nSamples); mvnrnd(MU3,SIGMA3,nSamples*2)];
figure;
scatter3(data(:,1),data(:,2),data(:,3),30,'.');
xlabel('X')
ylabel('Y')
zlabel('Z')

% clustering using the function KmeansSvd
class = KmeansSvd(data',k,useFit,plotFlag,'Example');

% classVals = unique(class);
colors = cellstr(['.r';'.b';'.g';'.y';'.k']);
figure;
for i = 1:5
scatter3(data(class==i,1),data(class==i,2),data(class==i,3),30,colors{i});
hold on
end
xlabel('X')
ylabel('Y')
zlabel('Z')
