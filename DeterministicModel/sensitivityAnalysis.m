function sensitivityVals = sensitivityAnalysis()
%{
Created by: Chris Cadonic
========================================
This function carries out a relative sensitivty analysis for the entire system
using the method outlined in Beard (2005).

E_star stores the error values when the model parameter values
are set to the estimated values achieved through calibration.

minusEvals and plusEvals then adjust each parameter to determine
how a 10% increase or 10% decrease in parameter value will
affect the error values. The maximum deviation from ideal
error provides a measure of how sensitive the model is to that
parameter.
%}

%% Setup for Sensitivity Analysis

% clear cmd history for clarity
clc

% intialize storage vectors
[E_star, minusEvals,plusEvals,sensitivityVals] = deal([]);

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

%% Evaluate E* and E*+/- 10%

% evalute E*, consistent across all parameter changes
E_star = sensitivitySolver(parameters,paramSet);

% evaluate E* of plus and minus 10 for each parameter
for param=1:numel(parameterIDs)
      parameterSet = paramSet;
      
      % Change parameter to be evaluated at minus 10%
      parameterSet.(parameterIDs{param}) = paramMT(param);
      minusEvals(param,1:5) = sensitivitySolver(parameters,parameterSet);
      
      % Change parameter to be evaluated at plus 10%
      parameterSet.(parameterIDs{param}) = paramPT(param);
      plusEvals(param,1:5) = sensitivitySolver(parameters,parameterSet);
      
      % store all the sensitivity vals in a matrix
      for cond=1:5
            sensitivityVals(param, cond) = max(abs(minusEvals(cond) ...
                  -E_star(cond))/(0.1*E_star(cond)),abs(plusEvals(cond) ...
                  -E_star(cond))/(0.1*E_star(cond)));
      end
      
      % calculate and display the sensitivity values
      disp(['Sensitivity values for parameter ', parameterIDs{param}, ' are: ', ...
            num2str(sensitivityVals(param,:))]);
end

% save results to a .mat and .txt file for viewing the sensitivity values
cd([folder '/SensitivityResults']); %change to Solutions folder
todayDate = date; %get the run date

% save the Best solution to the Solutions folder
resultsname = [todayDate '-SensitivityCoefficients'];
save(resultsname,'sensitivityVals');

disp(['Saving results to: ', resultsname]);