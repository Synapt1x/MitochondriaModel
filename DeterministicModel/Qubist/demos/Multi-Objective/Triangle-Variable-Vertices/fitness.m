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

function F=fitness(X,extPar)
% Qubist demo fitness function.

theta=X(1,:);
x=X(2,:);
y=X(3,:);

v1=[0; 0];
v2=[1; 0];
v3=[cos(theta); sin(theta)];

F1=((x-v1(1)).^2+(y-v1(2)).^2);
F2=((x-v2(1)).^2+(y-v2(2)).^2); 
F3=((x-v3(1,:)).^2+(y-v3(2,:)).^2);

F=[F1;F2;F3];
