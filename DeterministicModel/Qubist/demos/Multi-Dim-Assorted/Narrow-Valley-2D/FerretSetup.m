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
par.history.saveFrac=0.1; % Save only the optimals (0), a fraction (0 to 1), or everything?
% ====================================
% General
par.general.min=[-10,-10];
par.general.max=[10,10];
par.general.XLabels={'X','Y'};
par.general.FLabels={'F'};
par.general.NPop=2;
par.general.popSize=100;
par.general.NGen=1000;
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=1;
par.selection.FAbsTol=0.5;
% ====================================
% Mutation
par.mutation.PMutate=0.05;
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.PAntiXOver=0.2;
% ====================================
% Building Block Crossover
par.XOverBB.PXOver=1; % Probability of Building Block crossovers.
par.XOverBB.NPass=1; % Number of passes through BB selection per cycle.
% ====================================
% Niching
par.niching.X=0.25;
% ====================================
% Zooming
par.zoom.NGen=0;
% ====================================
% Linkage Learning
par.link.PLink=0.1;
% par.link.mixDim=0.1; % Greater than 0 if mixing is desired.  Usually range: [0,1], but could be higher.
% ====================================
% Elitism
par.elitism.frac=0.05; % Fraction of population that are elite.
% ====================================
% Graphics & messages
par.interface.myPlot='myPlot';
