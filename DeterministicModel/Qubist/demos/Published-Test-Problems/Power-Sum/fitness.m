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

function F=fitness(X)
% Power-sum function from Mishra 2006.
% Online at http://mpra.ub.uni-muenchen.de/1742/ 
% MPRA Paper No. 1742, posted 07. November 2007 / 01:57
% 
% Solution: f=0 for any permutation of  x=(1,2,2,3)

b=[8;18;44;114];
F=0;
for k=1:4
    F=F+(b(k)-sum(X.^k, 1)).^2;
end
