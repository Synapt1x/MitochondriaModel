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
par.general.min=[-10,-10,-10,-10];
par.general.max=[10,10,10,10];
par.general.XLabels={'X','Y'};
par.general.FLabels={'F'};
par.general.NPop=1;
par.general.popSize=250;
par.general.NGen=1000;
% ====================================
% Selection
par.selection.PTournament=1; % [0 - 1]: Natural selection: probability that each individual will compete.
par.selection.pressure=1; % [0 - 1]: Natural selection pressure on overall fitness.
par.selection.BBPressure=1; % [0 - 1]: Selection pressure on BBs.
par.selection.FAbsTol=0.25; % Absolute fitness range (+/- FAbsTol) to use as a fuzzy fitness band.
% par.selection.competitionRestriction=-1;
% ====================================
% Mutation
par.mutation.PMutate=0.1;
par.mutation.scale=0.25;
par.mutation.selectiveMutation=-0.5; % Negative values mutate highly clustered individuals selectively.
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.PAntiXOver=0.1;
par.XOver.dispersion=0.25;
par.XOver.matingRestriction.X=-1;
par.XOver.ALS=0;
% ====================================
% Niching
par.niching.X=0.25;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0.001; % [0 - 1]: Probability of gene deactivation.
par.CPD.PReactivateGenes=0.01; % [0 - 1]: Probability of gene reactivation.
par.CPD.useTemplates=false; % [logical]: Use templates to replace NaN's in evaluation when possible.
par.CPD.NaN2Random=true; %  [logical, usually true]: Replace undefined genes (NaN's) with random numbers?
% ====================================
% Elitism
par.elitism.frac=0.1; % Fraction of population that are elite.
% ====================================
% Zooming
par.zoom.NGen=10; % [integer >= 1]: Zoom control
% ====================================
% Graphics & messages
par.interface.myPlot='myPlot';
