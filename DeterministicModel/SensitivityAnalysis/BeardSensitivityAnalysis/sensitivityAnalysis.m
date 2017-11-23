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

% intialize storage vectors
[E_stars,sensitivityVals] = deal([]);

[parameters, data, models] = setup; %run the setup function which creates the
%structure storing all variables necessary
%for evaluating the model (found in 'setup.m')
origParameters = parameters;

% store the values of the parameters in a vector
[paramSet,paramMT,paramPT] = deal(parameters.ctrlParams);
paramVals = [paramSet.f0_Vmax, paramSet.f0_Km, paramSet.fIV_Vmax, ...
    paramSet.fIV_K, paramSet.fIV_Km, paramSet.fV_Vmax, paramSet.fV_K, ...
    paramSet.fV_Km, paramSet.p_alpha, paramSet.p_fccp, paramSet.cytcred, ...
    paramSet.cytcox, paramSet.amp_1, paramSet.amp_2, paramSet.amp_3, ...
    paramSet.amp_4, paramSet.cyt_c_drop];
origCytProp = paramSet.cytcred/paramSet.cytctot;

% store +/- 10% values in new structures
paramMT = structfun(@(x)x*0.9,paramSet);
paramPT = structfun(@(x)x*1.1,paramSet);

% names of each parameters as they are stored
parameterIDs = {'f0_Vmax', 'f0_Km', 'fIV_Vmax', 'fIV_K', 'fIV_Km', ...
    'fV_Vmax', 'fV_K', 'fV_Km', 'p_alpha', 'p_fccp', 'cytcred', 'cytcox', ...
    'amp_1', 'amp_2', 'amp_3', 'amp_4', 'cyt_c_drop'};

%% Evaluate E* and E*+/- 10%

% evalute E*, consistent across all parameter changes
E_star = sensitivitySolver(parameters, paramSet, data);

% evaluate E* of plus and minus 10 for each parameter
for param=1:numel(parameterIDs)
      parameterSet = paramSet;
      parameters = origParameters;
      
      if param==11
          parameters.cytcox = paramMT(param);
          parameters.cytctot = parameters.cytcred + parameters.cytcox;
          
          parameterSet.cytcred = parameters.cytcred;
          parameterSet.cytctot = parameters.cytctot;
      end
      if param==12
          parameters.cytctot = paramMT(param);
          parameters.cytcred = parameters.cytctot*origCytProp;
          parameters.cytcox = parameters.cytctot*(1-origCytProp);
          
          parameterSet.cytcred = parameters.cytcred;
          parameterSet.cytcox = parameters.cytcox;
          parameterSet.cytctot = parameters.cytctot;
      end
      
      % Change vmax to be evaluated at minus 10%
      parameterSet.(parameterIDs{param}) = paramMT(param);
      [~,minusEval] = solver(parameters,parameterSet, data, 'cc_full_model', ...
          models);
      
      % Change vmax to be evaluated at plus 10%
      parameterSet.(parameterIDs{param}) = paramPT(param);
      [~,plusEval] = solver(parameters,parameterSet, data, 'cc_full_model', ...
          models);
      
      % evaluate E*'s
      E_minus = sum((data.CtrlO2 - minusEval(:,2)).^2)/numel(data.CtrlO2);
      E_plus = sum((data.CtrlO2 - plusEval(:,2)).^2)/numel(data.CtrlO2);
      
      %store into sensitivity matrix
      E_stars(param,1) = E_minus;
      E_stars(param,2) = E_plus;
      
      sensitivityVals(param) = max(abs(E_stars(param,1)-E_star{1})/(0.1*E_star{1}), ...
            abs(E_stars(param,2)-E_star{1})/(0.1*E_star{1}));
      
      % calculate and display the sensitivity values
      disp(['Sensitivity for parameter ', parameterIDs{param}, ' is: ', ...
            num2str(sensitivityVals(param))]);
end

sensitivityVals = sensitivityVals ./ sum(sensitivityVals);

for param=1:numel(parameterIDs)
    disp(['NORMALIZED Sensitivity for parameter ', parameterIDs{param}, ' is: ', ...
            num2str(sensitivityVals(param))]);
end

% save results to a .mat and .txt file for viewing the sensitivity values
cd([folder '/SensitivityResults']); %change to Solutions folder
todayDate = date; %get the run date

% save the Best solution to the Solutions folder
resultsname = [todayDate '-SensitivityCoefficients'];
save(resultsname,'sensitivityVals');

disp(['Saving results to: ', resultsname]);