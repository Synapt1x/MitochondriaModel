function fitness = get_F(solution_params, parameters, data, models)
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

%% Determines if objective will be fitting ctrl data or 3xTg data
data_types = {'CtrlO2', 'AlzO2'};

% Update all the values in the ctrlParams parameter set in 'parameters'
for i=1:1:numel(fields)    
    parameters.ctrlParams.(fields{i}) = solution_params.(fields{i});
end

%% Calculate the fitness of this solution compared to data
%update all the parameteres necessary
parameters.cytcred = parameters.ctrlParams.cytcred;
parameters.cytcox = parameters.ctrlParams.cytcox;
parameters.cytctot = parameters.cytcred + parameters.cytcox;
parameters.Hn = parameters.ctrlParams.omega;
parameters.Hp = parameters.ctrlParams.rho;
parameters.O2 = parameters.ctrlParams.oxygen;
parameters.ctrlParams.cytctot = parameters.ctrlParams.cytcred ...
    + parameters.ctrlParams.cytcox;

tic();
warning off
%call ode to solve the system of equations for this solver
        %[~, y] = solver(parameters, params, data, selected_model, models);
[~, y] = solver(parameters, parameters.ctrlParams, data, 'cc_full_model', ...
    models);
warning on
toc()
        
%for fitting O2
try
    evaluations = y(:,2); %evaluated data for o2
    realo2Data = data.(data_types{parameters.data_fitting}); %exp o2 data
    
    %evaluate using a least-squares
    fitness = sum((realo2Data-evaluations).^2)/numel(realo2Data);
catch
    fitness = data.max_error;
end