function formattedDataMtx = removeOutliers(dataMtx)
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

% initialize variables
formattedDataMtx = dataMtx;
valsForRemoval = [];
whichBox = 0;

% build an initial boxplot without displaying it
boxplot(dataMtx);
set(gcf,'Visible','Off');

% extract outlier data
h = findobj(gcf,'tag','Outliers');
boxes = get(h,'XData');
outlierVals = get(h,'YData');

% find all outliers with |x|vals|
outliers = horzcat(boxes,outlierVals);

% remove outlier values from data matrix
for box = 1:size(outliers,1)
      
      if ~isnan(outliers{box,1})
            % find the current boxplot and the values of outliers
            whichBox = outliers{box,1}(1);
            valsForRemoval = outliers{box,2};
            
            % find where the outliers are in the matrix
            outlierIndxs = ismember(dataMtx(:,whichBox),valsForRemoval);
            
            % set these indices to NaNs
            formattedDataMtx(outlierIndxs,whichBox) = NaN;
            
      end
end