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

function myPlot(X, F, extPar)

index=find(F == min(F));
index=index(1);
C=X(1:extPar.K.NTerms, index);
phi=X(extPar.K.NTerms+1:end, index);

[x,f]=calcFunction(C, phi, extPar);

errorbar(extPar.x, extPar.f, extPar.sigma); hold on
plot(extPar.x, extPar.f0, 'k' ,x, f, 'r'); hold off
