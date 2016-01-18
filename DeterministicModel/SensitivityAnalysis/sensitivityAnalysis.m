function sensitivityVals = sensitivityAnalysis()
%{
Created by: Chris Cadonic
========================================
This function carries out a relative sensitivty analysis for the entire system
using the method outlined in Beard (2005).

In this file, MT = minus ten percent, and PT = plus ten percent
%}

%% Setup for Sensitivity Analysis

% clear cmd history for clarity
clc

% change folder to access solver without adding to path
folder = fileparts(which(mfilename)); %get the current folder
cd('..');

% intialize storage vectors
[E_stars,sensitivityVals] = deal([]);

parameters = setup; %run the setup function which creates the
%structure storing all variables necessary
%for evaluating the model (found in 'setup.m')

% store the values of the parameters in a vector
[paramSet,paramMT,paramPT] = deal(parameters.ctrlParams);
paramVals = [paramSet.f0Vmax, paramSet.f0Km, paramSet.Vmax, paramSet.Km, ...
      paramSet.K1, paramSet.p1, paramSet.p2, paramSet.p3, paramSet.Dh];

% store +/- 10% values in new structures
paramMT = structfun(@(x)x*0.9,paramSet);
paramPT = structfun(@(x)x*1.1,paramSet);

% names of each parameters as they are stored
parameterIDs = {'f0Vmax','f0Km','Vmax','Km','K1','p1','p2','p3','Dh'};

% acquire real data from the parameters structure
realData = parameters.realo2Data;

%% Evaluate E* and E*+/- 10%

% evalute E*, consistent across all parameter changes
[~,solutionEval] = solver(parameters,paramSet);
E_star = sum((realData-solutionEval(:,2)).^2)/numel(realData);

% evaluate E* of plus and minus 10 for each parameter
for param=1:numel(parameterIDs)
      parameterSet = paramSet;      
      
      % Change vmax to be evaluated at minus 10%
      parameterSet.(parameterIDs{param}) = paramMT(param);
      [~,minusEval] = solver(parameters,parameterSet);
      
      % Change vmax to be evaluated at plus 10%
      parameterSet.(parameterIDs{param}) = paramPT(param);
      [~,plusEval] = solver(parameters,parameterSet);
      
      % evaluate E*'s
      E_minus = sum((realData - minusEval(:,2)).^2)/numel(realData);
      E_plus = sum((realData - plusEval(:,2)).^2)/numel(realData);
      
      %store into sensitivity matrix
      E_stars(param,1) = E_minus;
      E_stars(param,2) = E_plus;
      
      sensitivityVals(param) = max(abs(E_stars(param,1)-E_star)/(0.1*E_star), ...
            abs(E_stars(param,2)-E_star)/(0.1*E_star));
      
      % calculate and display the sensitivity values
      disp(['Sensitivity for parameter ', parameterIDs{param}, ' is: ', ...
            num2str(sensitivityVals(param))]);
end

% change directory back into sensitivity analysis folder
cd('SensitivityAnalysis');

% save results to a .mat and .txt file for viewing the sensitivity values
cd([folder '/Results']); %change to Solutions folder
todayDate = date; %get the run date

% save the Best solution to the Solutions folder
resultsname = [todayDate '-SensitivityCoefficients'];
save(resultsname,'sensitivityVals');

disp(['Saving results to: ', resultsname]);

% move back to original directory
cd(folder);