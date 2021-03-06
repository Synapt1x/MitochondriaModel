function fitness = get_F(solution_params, parameters)
%{
Created by: Chris Cadonic
========================================
This function is called by analyzeResults in order to use solver
to determine the actual fitness of each optimal solution
provided by 'OptimalSolutions'.
%}

%% Setup
% Get field names from the solution vector
fields=fieldnames(solution_params);
fields(end)=[];

data_fitting=1; %%%%% 1 for ctrl data 2 for 3xTg data

% Update all the values in the ctrlParams parameter set in 'parameters'
for i=1:1:numel(fields)    
    parameters.ctrlParams.(fields{i}) = solution_params.(fields{i});
end

%% Calculate the fitness of this solution compared to data
%update all the parameteres necessary
parameters.Cytcred = parameters.ctrlParams.cytcred;
parameters.Cytcox = parameters.ctrlParams.cytcox;
parameters.Cytctot = parameters.Cytcred + parameters.Cytcox;
parameters.Hn = parameters.ctrlParams.omega;
parameters.Hp = parameters.ctrlParams.rho;
parameters.O2 = parameters.ctrlParams.oxygen;
parameters.ctrlParams.Cytctot = parameters.ctrlParams.cytcred ...
    + parameters.ctrlParams.cytcox;

warning off
%call ode to solve the system of equations for this solver
[t, y] = solver(parameters,parameters.ctrlParams);
warning on

%for fitting O2
evaluations = y(:,2); %evaluated data for o2
realo2Data = parameters.realo2Data(:,data_fitting); %use actual o2 data

try
    %evaluate using a least-squares
    fitness = sum((realo2Data-evaluations).^2)/numel(realo2Data);
catch
    fitness = inf;
end