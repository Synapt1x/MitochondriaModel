function [errors,solutionEval] = sensitivitySolver(parameters,params,varargin)
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
errors = [];

%Set the options for running ode45
options = odeset('NonNegative',[1,2,3,4]);

%format real data for 5 separate solutions
realData{1} = parameters.realo2Data;
realData{2} = realData{1}(1:parameters.oligoTime-1);
realData{3} = realData{1}(parameters.oligoTime: ...
      parameters.fccpTime-1);
realData{4} = realData{1}(parameters.fccpTime: ...
      parameters.inhibitTime-1);
realData{5} = realData{1}(parameters.inhibitTime:end);

%Solve by using ode for each section and passing along the final
%values as initial values for the next section
tic
[~,y1] = ode45(@baselineSystem, parameters.baselineTimes, ...
    [parameters.Cytcred,parameters.O2,parameters.Hn, ...
    parameters.Hp],options,params);
[~,y2] = ode45(@oligoSystem, parameters.oligoTimes, ...
    [y1(end,1),y1(end,2),y1(end,3),y1(end,4)],options,params);
[~,y3] = ode45(@fccpSystem, parameters.fccpTimes, ...
    [y2(end,1),y2(end,2),y2(end,3),y2(end,4)],options,params);
[~,y4] = ode45(@inhibitSystem, parameters.inhibitTimes, ...
    [y3(end,1),y3(end,2),y3(end,3),y3(end,4)],options,params);

%store the first, solution for the entire model
solutionEval{1} = [y1;y2;y3;y4];

%if varargin in nonempty, then this is calculating Estar
if ~isempty(varargin)
      parameters.initialsOligo = y1(end,:);
      parameters.initialsFccp = y2(end,:);
      parameters.initialsInhibit = y3(end,:);
end

%repeat solving the system for each section separately
[~,solutionEval{2}] = ode45(@baselineSystem, parameters.baselineTimes, ...
    [parameters.Cytcred,parameters.O2,parameters.Hn, ...
    parameters.Hp],options,params);
[~,solutionEval{3}] = ode45(@oligoSystem, parameters.oligoTimes, ...
    parameters.initialsOligo,options,params);
[~,solutionEval{4}] = ode45(@fccpSystem, parameters.fccpTimes, ...
    parameters.initialsFccp,options,params);
[~,solutionEval{5}] = ode45(@inhibitSystem, parameters.inhibitTimes, ...
    parameters.initialsInhibit,options,params);

% loop over and calculate the error for each condition
for condition = 1:numel(solutionEval) 
      % calculate error for the entire model
      errors(condition) = sum((realData{condition}-solutionEval{condition}(:,2)).^2) ...
            /numel(realData{condition});      
end
toc