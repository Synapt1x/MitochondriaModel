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

% create box plots, one for each substrate in simulation and one for each
% equation provided for the sensitivity analysis
for substrate=1:8
      if substrate < 5
            figure(substrate);
            boxplot(dataMatrix(:,substrate));
      else
            figure(substrate);
            boxplot(dataMatrix(:,9*substrate-40:9*substrate-32));
      end
end

%calculate the PRCCs for the sensitivity coefficients
disp('The prccs for this system are: ')
prccs = partialcorr(dataMatrix(:,5:end));