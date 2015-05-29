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
NGenes=10;
par.general.min=-12+zeros(1,NGenes);
par.general.max=12+zeros(1,NGenes);
par.general.XLabels={'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'};
par.general.FLabels={'F_A', 'F_B', 'F_C'};
par.general.NPop=1;
par.general.popSize=250;
par.general.NGen=100000;
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=1;
% ====================================
% Niching
par.niching.F=0.2;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0.001;
par.CPD.PReactivateGenes=0.01;
par.CPD.NaN2Random=1;
% ====================================
% Mutation
par.mutation.PMutate=0.05;
par.mutation.selectiveMutation=0;
% ====================================
% Crossover
par.XOver.PXOver=1.0;  % Cross-over probability
par.XOver.PXOverBB=0.01;
par.XOver.PAntiXOver=0.1; 
par.XOver.dispersion=0.25;
par.XOver.matingRestriction.X=-0;
% ====================================
% Elitism
par.elitism.frac=0.05; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=0.25;
% ====================================
% Zooming
par.zoom.NGen=5;
par.zoom.safety=1;
% ====================================
% Interface
par.interface.xAxis.type='X';
par.interface.xAxis.value=3;
par.interface.yAxis.type='X';
par.interface.yAxis.value=7;
