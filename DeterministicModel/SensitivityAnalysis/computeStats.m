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

% create box plots, one for each substrate in simulation and one for each
% equation provided for the sensitivity analysis
for substrate=1:8
      if substrate < 5
            figure(substrate);
            
            dataMatrix(:,substrate) = removeOutliers(dataMatrix(:,substrate));
            
            % re-draw boxplot
            set(gcf,'Visible','On');
            boxplot(dataMatrix(:,substrate));
      else
            figure(substrate);
            
            dataMatrix(:,9*substrate-40:9*substrate-32) = ...
                  removeOutliers(dataMatrix(:,9*substrate-40:9*substrate-32));
            
            % re-draw boxplot
            set(gcf,'Visible','On');
            boxplot(dataMatrix(:,9*substrate-40:9*substrate-32));
      end
end