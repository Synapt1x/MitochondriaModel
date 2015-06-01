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

activeGenes=[3,7];

x=X(activeGenes(1),:);
y=X(activeGenes(2),:);
% z=X(activeGenes(3),:);

F1=((x-0).^2+(y-4).^2);
F2=((x-4).^2+(y+4).^2); 
F3=((x+4).^2+(y+4).^2);

F=[F1;F2;F3];

sz=size(F);
r=rand(sz(1),sz(2));

auxOutput={};
saveData={};

index=find(isnan(F));
F(index)=Inf;
