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
par.history.saveOnlyOptimals=1;
% ====================================
% General
par.general.min=-10+zeros(1,10);
par.general.max=10+zeros(1,10);
par.general.XLabels={'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'};
par.general.FLabels={'F_A', 'F_B', 'F_C'};
par.general.NPop=1;
par.general.popSize=500;
par.general.NGen=100000;
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=0.75;
% ====================================
% Niching
par.niching.X=0.2;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0;
% ====================================
% Mutation
par.mutation.PMutate=0.05;
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.PAntiXOver=0.1; 
% ====================================
% Elitism
par.elitism.frac=0.05; % Fraction of population that are elite.
% ====================================
% Interface
par.interface.xAxis.type='X';
par.interface.xAxis.value=3;
par.interface.yAxis.type='X';
par.interface.yAxis.value=7;
