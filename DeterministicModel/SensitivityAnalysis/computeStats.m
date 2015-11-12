function computeStats(dataMatrix)
%{
Created by: Chris Cadonic
========================================
This function carries out the calculations and creation of a figure
for the statistics of an input senstivity analysis vector.

This function is heavily used in the 'sensitivityAnalysis.m' file
for carrying out statistical analysis on the equilibrium values
for the LHS sampling matrix input into either the model or the
sensitivity coefficients.

%}

% firstly compute the mean and variance of each value
meanVals = mean(dataMatrix,1);
deviationVals = std(dataMatrix,0,1);
varianceVals = deviationVals.^2;

% ignore outliers that are greater/less than 2 standard deviations
% from the mean
for column=1:size(dataMatrix,2)
      dataMatrix(dataMatrix(:,column)>meanVals(column)+2*deviationVals(column), ...
            column)=NaN;
      dataMatrix(dataMatrix(:,column)<meanVals(column)-2*deviationVals(column), ...
            column)=NaN;
end

boxplot(dataMatrix);