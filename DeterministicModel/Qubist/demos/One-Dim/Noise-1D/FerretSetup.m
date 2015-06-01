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
par.general.popSize=250;
par.general.NGen=1000;
par.general.noisy=1; % [0 or 1]: Does the fitness function contain noisy fluctuations?
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=1;
% par.selection.FAbsTol=100;
% ====================================
% Mutation
par.mutation.PMutate=0.05;
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.PAntiXOver=0; 
par.XOver.matingRestriction.X=-0.5;
par.XOver.dispersion=0.05;  % Low dispersion.
% ====================================
% Elitism
par.elitism.frac=0.1; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=0;
% ====================================
% Graphics & messages
par.interface.myPlot='myPlot';
