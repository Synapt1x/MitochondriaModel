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

function par=FerretSetupBatch(par)
%
% ----------------------------------------------------------------
% This setup file is only meant to demonstrate the batchLauncher.m
% program in the main directory.
disp('')
disp(' *** CYCLIC-PARAMETERS-2D: SETUP FILE CALLED FROM BATCHLAUNCHER.M ***')
disp('')
% ----------------------------------------------------------------
%
% ====================================
% User
par.user.fitnessFcn='fitness';
% ====================================
% Data
% ====================================
% General
par.general.min=[0,0];
par.general.max=2*pi*[1,1];
par.general.cyclic=[1,2];
par.general.XLabels={'\theta','\phi'};
par.general.FLabels={'F'};
par.general.NPop=1;
par.general.popSize=100;
par.general.NGen=10;
% ====================================
% Selection
par.selection.FAbsTol=0.1;
par.selection.clusterScale=0.25;
% ====================================
% Mutation
par.mutation.PMutate=0.03;
par.mutation.selectiveMutation=-1; % Negative values mutate highly clustered individuals selectively.
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.PAntiXOver=0.1;
par.XOver.matingRestriction.X=-0.5;
% ====================================
% Niching
par.niching.X=0.25;
% ====================================
% Elitism
par.elitism.frac=0.05; % Fraction of population that are elite.
% ====================================
% Graphics & messages
par.interface.myPlot='myPlot';
par.zoom.NGen=10;
