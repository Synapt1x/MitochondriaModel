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

% get the current directory
curdir = fileparts(which(mfilename));

% intialize storage vectors
[minusEvals,plusEvals,sensitivityVals] = deal([]);

parameters = setup; %run the setup function which creates the
%structure storing all variables necessary
%for evaluating the model (found in 'setup.m')
origParameters = parameters;

% store the values of the parameters in a vector
paramSet = parameters.ctrlParams;
paramVals = [paramSet.f0Vmax, paramSet.f0Km, paramSet.Vmax, paramSet.Km, ...
    paramSet.K1, paramSet.p1, paramSet.p2, paramSet.p3, paramSet.Dh, ...
    paramSet.cytcred, paramSet.cytcox, paramSet.Cytctot];
origCytProp = paramSet.cytcred/paramSet.Cytctot;

% store +/- 10% values in new structures
paramMT = structfun(@(x)x*0.9,paramSet);
paramPT = structfun(@(x)x*1.1,paramSet);

% names of each parameters as they are stored
parameterIDs = {'Vmax','K1','Km','p1','p2','p3','f0Vmax','f0Km','Dh', ...
    'cytcred','cytcox','none','none','none','Cytctot'};

%% Evaluate E* and E*+/- 10%

% evalute E*, consistent across all parameter changes
[E_star,evaluations] = sensitivitySolver(parameters,paramSet,'Estar');

% evaluate E* of plus and minus 10 for each parameter
for param=1:numel(parameterIDs)
    if (param==12)||(param==13)||(param==14)
        continue
    else
        parameterSet = paramSet;
        parameters = origParameters;

        % Change parameter to be evaluated at minus 10%
        parameterSet.(parameterIDs{param}) = paramMT(param);
        if param==10
            parameters.Cytcred = paramMT(param);
            parameters.Cytctot = parameters.Cytcred + parameters.Cytcox;

            parameterSet.cytcox = parameters.Cytcox;
            parameterSet.Cytctot = parameters.Cytctot;
        end
        if param==11
            parameters.Cytcox = paramMT(param);
            parameters.Cytctot = parameters.Cytcred + parameters.Cytcox;

            parameterSet.cytcred = parameters.Cytcred;
            parameterSet.Cytctot = parameters.Cytctot;
        end
        if param==12
            parameters.Cytctot = paramMT(param);
            parameters.Cytcred = parameters.Cytctot*origCytProp;
            parameters.Cytcox = parameters.Cytctot*(1-origCytProp);

            parameterSet.cytcred = parameters.Cytcred;
            parameterSet.cytcox = parameters.Cytcox;
            parameterSet.Cytctot = parameters.Cytctot;
        end
        %{
            %%%%%Proportions
        if param==10

            parameters.Cytcred = paramMT(param);
            parameters.Cytctot = parameters.Cytcred/origCytProp;
            parameters.Cytcox = parameters.Cytctot - parameters.Cytcred;
            parameterSet.cytcred = parameters.Cytcred;
            parameterSet.cytcox = parameters.Cytcox;
            parameterSet.Cytctot = parameters.Cytctot;
        end
        if param==11
            parameters.Cytcox = paramMT(param);
            parameters.Cytctot = parameters.Cytcox/(1-origCytProp);
            parameters.Cytcred = parameters.Cytctot - parameters.Cytcox;
            parameterSet.cytcred = parameters.Cytcred;
            parameterSet.cytcox = parameters.Cytcox;
            parameterSet.Cytctot = parameters.Cytctot;
        end
        %}
        minusEvals(param) = sensitivitySolver(parameters,parameterSet);

        % Change parameter to be evaluated at plus 10%
        parameterSet.(parameterIDs{param}) = paramPT(param);
        if param==10
            parameters.Cytcred = paramPT(param);
            parameters.Cytctot = parameters.Cytcred + parameters.Cytcox;

            parameterSet.cytcox = parameters.Cytcox;
            parameterSet.Cytctot = parameters.Cytctot;
        end
        if param==11
            parameters.Cytcox = paramPT(param);
            parameters.Cytctot = parameters.Cytcred + parameters.Cytcox;

            parameterSet.cytcred = parameters.Cytcred;
            parameterSet.Cytctot = parameters.Cytctot;
        end
        if param==12
            parameters.Cytctot = paramPT(param);
            parameters.Cytcred = parameters.Cytctot*origCytProp;
            parameters.Cytcox = parameters.Cytctot*(1-origCytProp);

            parameterSet.cytcred = parameters.Cytcred;
            parameterSet.cytcox = parameters.Cytcox;
            parameterSet.Cytctot = parameters.Cytctot;
        end
        %{
        %%%%%%Proportions
        if param==10
            parameters.Cytcred = paramPT(param);
            parameters.Cytctot = parameters.Cytcred/origCytProp;
            parameters.Cytcox = parameters.Cytctot - parameters.Cytcred;
            parameterSet.cytcred = parameters.Cytcred;
            parameterSet.cytcox = parameters.Cytcox;
            parameterSet.Cytctot = parameters.Cytctot;
        end
        if param==11
            parameters.Cytcox = paramPT(param);
            parameters.Cytctot = parameters.Cytcox/(1-origCytProp);
            parameters.Cytcred = parameters.Cytctot - parameters.Cytcox;
            parameterSet.cytcred = parameters.Cytcred;
            parameterSet.cytcox = parameters.Cytcox;
            parameterSet.Cytctot = parameters.Cytctot;
        end
        %}
        if param==9
            plusEvals(param) = minusEvals(param);
        else
            plusEvals(param) = sensitivitySolver(parameters,parameterSet);
        end

        sensitivityVals(param) = max(abs(minusEvals(param) ...
            -E_star)/(0.1*E_star),abs(plusEvals(param)-E_star)/(0.1*E_star));

        % calculate and display the sensitivity values
        disp(['Sensitivity values for parameter ', parameterIDs{param}, ' are: ', ...
            num2str(sensitivityVals(param))]);
    end
end


% save results to a .mat and .txt file for viewing the sensitivity values
cd([curdir, '/SensitivityResults']); %change to Solutions folder
todayDate = date; %get the run date

% save the Best solution to the Solutions folder
resultsname = [todayDate '-SensitivityCoefficients'];
save(resultsname,'sensitivityVals');

disp(['Saving results to: ', resultsname]);
