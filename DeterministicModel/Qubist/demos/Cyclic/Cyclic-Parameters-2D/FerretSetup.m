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
par.general.min=[0,0];
par.general.max=2*pi*[1,1];
par.general.cyclic=[1,2];
par.general.XLabels={'\theta','\phi'};
par.general.FLabels={'F'};
par.general.NPop=4;
par.general.popSize=100;
par.general.NGen=1000;
% ====================================
% Selection
par.selection.FAbsTol=0.1;
par.selection.clusterScale=0.25;
% ====================================
% Mutation
par.mutation.PMutate=0.03;
par.mutation.selectiveMutation=-1; % Negative values mutate highly clustered individuals selectively.
% ====================================
% Local Optimization
par.localOpt.startGen=10; % [integer]: First generation for local optimization. (Inf or NaN for no set start generation)
par.localOpt.maxNMoves=250; % [integer]: Maximum number of moves allowed for each local optimization.
par.localOpt.maxFEval=NaN; % [integer]: Maximum number of evaluations allowed for each local optimization.
par.localOpt.startF=NaN; % [real]: Trigger local optimization when fitness falls below some value. (NaN for no trigger)
par.localOpt.convergeWindow=50; % [integer > 1]: The length of the window (in generations) used to monitor for convergence.
par.localOpt.startFTol=0; % [real]: Trigger local optimization when the change in fitness drops below this value (single-objective only).
par.localOpt.startWhenConverged=false; % [logical]: Trigger local optimization when population appears converged.
par.localOpt.POptimizeOnImprovement=0.1; % [0 - 1]: Probability of optimization after improvement of best solution.
par.localOpt.POptimizeOnNoImprovement=0.1; % [0 - 1]: Probability of optimization after no improvement of best solution.
par.localOpt.tolX=1e-6; % [real > 0, usually small]: Tolerance in X for local optimization.
par.localOpt.tolF=1e-6; % [real > 0, usually small]: Tolerance in F for local optimization.
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
