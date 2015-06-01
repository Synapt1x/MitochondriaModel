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
NGenes=10; % The ACTUAL number of dimensions.  Must be <= ND in init.m.
par.general.min=-12+zeros(1,NGenes);
par.general.max=12+zeros(1,NGenes);
par.general.XLabels={'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'};
par.general.FLabels={'F_A', 'F_B', 'F_C'};
par.general.NPop=1;
par.general.popSize=100;
par.general.NGen=200;
% ====================================
% Selection
% ***It appears that using sexual selection (PPreferSuperiorMates > 0) rather than
% natural selection (PTournament > 0) results in a denser Pareto front.  This makes
% sense because there is more mating between individuals residing on or near the Pareto
% surface.  (This could use more testing to be sure that the effect noted here is real.)
par.selection.PPreferSuperiorMates=1;
par.selection.PTournament=0;
%
par.selection.pressure=1;
par.selection.FAbsTol=0;
par.selection.clusterScale=0.1;
par.selection.minimizeEachObjective=0.5;
% ====================================
% Niching
par.niching.X=0.25;
par.niching.F=0.3;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0;
par.CPD.PReactivateGenes=0.01;
% ====================================
% Mutation
par.mutation.PMutate=0.05;
par.mutation.selectiveMutation=-1;
% ====================================
% Crossover
par.XOver.PXOver=1.0;  % Cross-over probability
par.XOver.PXOverBB=1;
par.XOver.PAntiXOver=0.1;
% par.XOver.matingRestriction.X=0;
% par.XOver.matingRestriction.F=-0.7;
% ====================================
% Elitism
par.elitism.frac=0.1; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=0; % [0:1]: Probability that an individual will be chosen for linkage learning.
% ====================================
% Zooming
par.zoom.NGen=5;
par.zoom.safety=0.5; % [real, usually <= 1]
par.zoom.allowZoomOut=1; % [0 or 1]
% ====================================
% Interface
par.interface.xAxis.type='X';
par.interface.xAxis.value=1;
par.interface.yAxis.type='X';
par.interface.yAxis.value=2;
par.interface.yAxis.type='X';
par.interface.yAxis.value=3;

