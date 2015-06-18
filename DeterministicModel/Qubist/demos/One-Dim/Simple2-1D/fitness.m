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

function [F,auxOutput]=fitness(X, extPar)
% Qubist demo fitness function.

for i=length(X):-1:1
    % pause(0.1);
    if isAbortEval(extPar.status)
        return
    end
    F(i)=abs(X(i));
    auxOutput{i}=F(i);
end

% F=abs(X);
% auxOutput=num2cell(F);
