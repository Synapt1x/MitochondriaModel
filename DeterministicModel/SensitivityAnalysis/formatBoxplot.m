function formatBoxplot(dataMtx, label, ylab)
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
% Add export_fig function to path for use
cd('..');
addpath([pwd,'/AdditionalFuncs']);
cd('SensitivityAnalysis');


% initialize the variables used
[firstQuart,thirdQuart,meanVal,median] = deal([]);

% calculate the descriptive statistics on each column in dataMtx
for variable=1:size(dataMtx,2)
      
      % calculate the descriptive statistics
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

% find the bounds for the boxplot axis
[minVal,minBox] = min(firstQuart);
[maxVal,maxBox] = max(thirdQuart);
lb = minVal - 1.1*(thirdQuart(minBox)-minVal);
ub = maxVal + 1.1*(maxVal-firstQuart(maxBox));

% reformat the axis for the boxplot
axis([0.5,size(dataMtx,2)+0.5,lb,ub]);
title(label);

% label the boxplot
ylabel(ylab);

% set the background to white
set(gcf,'color','w');

% remove x axis label
set(gca,'XTick',[]);

testlabel = 'test';
export_fig(testlabel)