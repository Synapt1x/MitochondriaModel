function formatBoxplot(dataMtx, label, ylab, boxplot_title)
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

% initialize the variables used
[firstQuart,thirdQuart,meanVal,median] = deal([]);

% calculate the descriptive statistics on each column in dataMtx
for variable=1:size(dataMtx,2)
      % calculate the descriptive statistics for the boxplot
      quartiles = quantile(dataMtx(:,variable),[0.25 0.5 0.75]);
      firstQuart(variable) = quartiles(1);
      median(variable) = quartiles(2);
      thirdQuart(variable) = quartiles(3);
      meanVal(variable) = mean(dataMtx(:,variable));
end

%% Create boxplot and edit figure properties
% draw the boxplot
boxFig = boxplot(dataMtx);

% remove outliers from displaying
set(boxFig(7,:),'Visible','Off');

% set the background to white
set(gcf,'color','w');

% Add axis labels
set(gca,'XTickLabel',{label{:}});
set(gca, 'XTickLabelRotation', -45);
ylabel(ylab);

% Add a title
title(boxplot_title);