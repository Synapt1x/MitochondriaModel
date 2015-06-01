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

function F=fitness(X, extPar)
% Function with several islands of solutions.

[NDim,N]=size(X);
NIslands=size(extPar.X0,2);

F=zeros(1,N);
for i=1:NIslands
    F1=1/NDim*sum((bsxfun(@minus, X, extPar.X0(:,i))/extPar.scale(i)).^2,1)-extPar.depth(i);
    F1(F1 > 0)=0;
    F=F+F1;
end
