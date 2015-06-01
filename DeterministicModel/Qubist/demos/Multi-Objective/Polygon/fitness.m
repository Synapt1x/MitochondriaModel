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

[NGenes,N]=size(X);
V=extPar.vertices;

F1=sqrt(sum((X-repmat(V{1}(1:NGenes),1,N)).^2));
F2=sqrt(sum((X-repmat(V{2}(1:NGenes),1,N)).^2));
F3=sqrt(sum((X-repmat(V{3}(1:NGenes),1,N)).^2));
F4=sqrt(sum((X-repmat(V{4}(1:NGenes),1,N)).^2));
F5=sqrt(sum((X-repmat(V{5}(1:NGenes),1,N)).^2));

F=abs([F1;F2;F3;F4;F5]);
