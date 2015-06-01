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
% Corana function from Mishra 2006.
% Online at http://mpra.ub.uni-muenchen.de/1742/ 
% MPRA Paper No. 1742, posted 07. November 2007 / 01:57
%
% Solution: F_min(0, 0, 0, 0)=0 

N=size(X,2);
D=repmat([1;1000;10;100], 1, N);
Z=0.2*abs(abs(X/0.2)+0.49999).*sign(X);
alpha=abs(X-Z) < 0.05;
F=sum( alpha*0.15.*(Z-0.05*sign(Z)).^2.*D+...
    ~alpha.*D.*X.^2, 1);
