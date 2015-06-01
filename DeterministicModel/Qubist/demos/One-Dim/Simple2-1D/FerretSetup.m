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

function par=FerretSetup(par)
%
% ====================================
% User
par.user.fitnessFcn='fitness';
% ====================================
% Data
% ====================================
% General
par.general.min=-10;
par.general.max=10;
par.general.XLabels={'X'};
par.general.FLabels={'F'};
par.general.NPop=1;
par.general.popSize=100;
par.general.NGen=250;
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.FAbsTol=1;
% ====================================
% Mutation
par.mutation.PMutate=0.05;
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.PAntiXOver=0.1; 
% ====================================
% Niching
par.niching.X=0.3;  % [0 - 1]: X-Niching: Typically ~0.25 is about right.
% ====================================
% Elitism
par.elitism.frac=0.05; % Fraction of population that are elite.
% ====================================
% Graphics & messages
par.interface.myPlot='myPlot';
