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

function [F, auxOutput]=fitness(X, extPar)
% Qubist demo fitness function.

x1=X(1,:);
x2=X(2,:);

q=4; alpha=2;
F1=x1;
F2=(1+10*x2).*(1-(x1./(1+10*x2)).^alpha-...
    (x1./(1+10*x2)).*sin(2*pi*q*x1));

F=[F1;F2];

% Optional.  This is just to test the auxOutput system.
for i=1:length(F1)
    auxOutput{i}.F1=F1(i);
    auxOutput{i}.F2=F2(i);
end
