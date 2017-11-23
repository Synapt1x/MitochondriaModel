function errors = sensitivitySolver(parameters,params, data)
%{
Created by: Chris Cadonic
========================================
This function solves the full situation for my model by step-wise
solving the ODEs for each section using the appropriate equations.

Additionally, this function also solves for each condition in my model,
and is specifically made for the sensitivity analysis. Thus, the output
of this function is not the raw values, but instead the error values
calculated.
%}

%initialize variables
errors = {};

%Set the options for running ode45
options = odeset('NonNegative',[1,2,3,4]);

initial_params = [params.cytcred, params.oxygen, params.omega, params.rho];

%Solve by using ode for each section and passing along the final
%values as initial values for the next section
tic
[t1,y1] = ode23t(@oligoFccpSystem, [data.baseline_times; ...
    data.oligo_fccp_times], initial_params,options,params);
[t2,y2] = ode23t(@inhibitSystem, data.inhibit_times, ...
    [params.cyt_c_drop * y1(end,1), y1(end,2), y1(end,3), ...
    y1(end,4)], options,params);

t = [t1; t2];
y = [y1; y2];
toc

%store the first, solution for the entire model
solutionEval{1} = y;

%repeat solving the system for each section separately
[~, solutionEval{2}] = ode23t(@oligoFccpSystem, [data.baseline_times; ...
    data.oligo_fccp_times], initial_params,options,params);
[~, solutionEval{3}] = ode23t(@inhibitSystem, data.inhibit_times, ...
    [params.cyt_c_drop * y1(end,1), y1(end,2), y1(end,3), ...
    y1(end,4)], options,params);

%format real data for 5 separate solutions
realData{1} = data.CtrlO2;
realData{2} = [data.baseline_times; data.oligo_fccp_times];
realData{3} = data.inhibit_times;

% loop over and calculate the error for each condition
for condition = 1:numel(solutionEval) 
      % calculate error for the entire model
      errors{condition} = sum((realData{condition}-solutionEval{condition}(:,2)).^2) ...
            /numel(realData{condition});      
end

      
      
      
      
      
      
      
      

