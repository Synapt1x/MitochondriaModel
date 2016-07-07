%
% Qubist 5: A Global Optimization, Modeling & Visualization Toolbox for MATLAB
%
% Ferret: A Multi-Objective Linkage-Learning Genetic Algorithm
% Locust: A Multi-Objective Particle Swarm Optimizer
% Anvil: A Multi-Objective Simulated Annealing/Genetic Algorithm Hybrid
% SAMOSA: Simple Approach to a Multi-Objective Simplex Algorithm
%
% Copyright 2002-2015. nQube Technical Computing Corp. All rights reserved.
% Author: Jason D. Fiege, Ph.D.
% design.innovate.optimize @ www.nQube.ca
% ============================================================================

function myPlot(X,F,extPar)

[~,index]=find(F == min(F));
X=X(index);

parameters=extPar.parameters;
f=fields(X);
f(strcmpi(f,'info'))=[];

for i=1:length(f)
    parameters.(f{i})=X.(f{i});
end

%call ode to solve the system of equations for this solver
[t y] = ode45(@decoupled_derivative_system,parameters.time_points, ...
    parameters.initial_conditions,[],parameters);

%call custom interpolation function to find OCR at the seahorse points
%     ocr_evaluations = weighted_interp(t,y(:,2),y(:,1),y(:,3),...
%         t_points,parameters); %call is for (t, O2, cytc red, h_n,...)
%this has been commented out since this evaluates OCR values and not O2

realData = parameters.realData(:,2); %replicate actual data

plot(parameters.time_points, realData, 'k+',...
    parameters.time_points, y(:,2), 'r');

