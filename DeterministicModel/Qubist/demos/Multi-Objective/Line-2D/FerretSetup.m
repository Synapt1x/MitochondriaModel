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
par.general.min=[-1,-1];
par.general.max=[1,1];
par.general.NPop=1;
par.general.popSize=250;
par.general.NGen=100000;
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.FAbsTol=0;
par.selection.pressure=1;
% par.selection.clusterScale=0.1;
% ====================================
% Niching
par.niching.X=0.25;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0;
par.CPD.PReactivateGenes=0;
par.CPD.NaN2Random=1;
% ====================================
% Mutation
par.mutation.PMutate=0.1;
% ====================================
% Crossover
par.XOver.PXOver=1.0;  % Cross-over probability
par.XOver.PXOverBB=1;
% par.XOver.PAntiXOver=0.1;
par.niching.acceleration=1;
% ====================================
% Elitism
par.elitism.frac=0.05; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=0.1;
% ====================================
% Interface
par.interface.xAxis.type='X';
par.interface.xAxis.value=3;
par.interface.yAxis.type='X';
par.interface.yAxis.value=7;
