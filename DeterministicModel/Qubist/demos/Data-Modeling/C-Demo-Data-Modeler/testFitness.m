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

function testFitness

NIndiv=3;
extPar=init;
X=rand(2*extPar.K.NTerms, NIndiv);
F=fitness(X, extPar);
F2=mxFitness(X,extPar);

disp(['Should be ALL ZEROS (or very, very small) if C code is working: ', mat2str(F-F2)]);
