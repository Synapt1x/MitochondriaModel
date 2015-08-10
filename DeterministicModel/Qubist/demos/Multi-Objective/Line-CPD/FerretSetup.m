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
par.general.FLabels={'F_A', 'F_B'};
par.general.NPop=1;
par.general.popSize=100;
par.general.NGen=100000;
% ====================================
% Selection
par.selection.PTournament=1;
% ====================================
% Niching
par.niching.X=0.3;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0.001;
par.CPD.PReactivateGenes=0.01;
% ====================================
% Mutation
par.mutation.PMutate=0.05;
% ====================================
% Crossover
par.XOver.PXOver=1.0;  % Cross-over probability
par.XOver.PAntiXOver=0.001; 
% ====================================
% Building Block Crossover
par.XOverBB.PXOver=1; % Probability of Building Block crossovers.
% ====================================
% Immigration
par.immigration.PImmigrate=0.;
% ====================================
% Elitism
par.elitism.frac=0.05; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=0.25;
par.link.useOptimalDonors=0;
% ====================================
% Interface
par.interface.xAxis.type='F';
par.interface.xAxis.value=1;
par.interface.yAxis.type='F';
par.interface.yAxis.value=2;
