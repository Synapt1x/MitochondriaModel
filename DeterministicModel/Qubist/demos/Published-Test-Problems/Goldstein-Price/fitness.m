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
% Goldstein-Price function from Mishra 2006.
% Online at http://mpra.ub.uni-muenchen.de/1742/ 
% MPRA Paper No. 1742, posted 07. November 2007 / 01:57
% 
% Solution: F_min(0,-1)=3

x1=X(1,:);
x2=X(2,:);
f1=1+(x1+x2+1).^2.*(19-14*x1+3*x1.^2-14.*x2+6*x1.*x2+3*x2.^2);
f2=30+(2*x1-3*x2).^2.*(18-32*x1+12*x1.^2+48*x2-36*x1.*x2+27*x2.^2);
F=f1.*f2;
