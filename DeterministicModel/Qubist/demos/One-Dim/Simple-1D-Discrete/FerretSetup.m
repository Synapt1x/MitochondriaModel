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
par.general.min=-100;
par.general.max=100;
par.general.discreteStep=1;
par.general.XLabels={'X'};
par.general.FLabels={'F'};
par.general.softMax=1;
par.general.NPop=1;
par.general.popSize=100;
par.general.NGen=250;
% ====================================
% Selection
par.selection.PTournament=1;
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
% Local Optimization
par.localOpt.startGen=10;
par.localOpt.POptimizeOnImprovement=1;
par.localOpt.POptimizeOnNoImprovement=1;
par.localOpt.maxFEval=100;
par.localOpt.tolX=1e-6;
par.localOpt.tolF=1e-6;
% ====================================
% Graphics & messages
par.interface.myPlot='myPlot';
par.zoom.NGen=10;
