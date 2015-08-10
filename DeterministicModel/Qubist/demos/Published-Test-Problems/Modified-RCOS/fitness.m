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
% Modified RCos function from Mishra 2006.
% Online at http://mpra.ub.uni-muenchen.de/1742/ 
% MPRA Paper No. 1742, posted 07. November 2007 / 01:57
%
% Solution: F_min(-3.196989, 12.52626)= -0.179891

g=1/(8*pi);
b=5.1/(4*pi^2);
c=5/pi;
a=1;
d=6;
e=10;

x1=X(1,:);
x2=X(2,:);
f1=a*(x2-b*x1.^2+c*x1-d).^2;
f2=e*(1-g)*cos(x1).*cos(x2);
f3=log(x1.^2+x2.^2+1);
F=-1./(f1+f2+f3+e);
