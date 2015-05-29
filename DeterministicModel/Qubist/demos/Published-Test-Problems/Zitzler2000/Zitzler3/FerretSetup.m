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
m=par.user.extPar.m;
par.general.min=zeros(1,m);
par.general.max=ones(1,m);
par.general.NPop=1;
par.general.popSize=100;
par.general.NGen=250;
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=1;
par.selection.BBPressure=1;
% ====================================
% Niching
par.niching.F=0.35;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0;
par.CPD.PReactivateGenes=0;
% ====================================
% Mutation
par.mutation.PMutate=0.05;
par.mutation.selectiveMutation=-1;
% ====================================
% Crossover
par.XOver.PXOver=1.0;  % Cross-over probability
par.XOver.PAntiXOver=0.1; 
% ====================================
% Immigration
par.immigration.PImmigrate=0.;
% ====================================
% Elitism
par.elitism.frac=0.1; % Fraction of population that are elite.
% ====================================
% Zooming
par.zoom.NGen=0;
par.zoom.safety=0.5; % [real, usually <= 1]
par.zoom.allowZoomOut=0; % [0 or 1]
% ====================================
% Local Optimization
par.localOpt.startGen=Inf; % [integer]: First generation for local optimization. (Inf or NaN for no set start generation)
par.localOpt.startF=NaN; % [real]: Trigger local optimization when fitness falls below some value. (NaN for no trigger)
par.localOpt.convergeWindow=10; % [integer > 1]: The length of the window (in generations) used to monitor for convergence.
par.localOpt.startFTol=0.01; % [real]: Trigger local optimization when the change in fitness drops below this value (single-objective only).
par.localOpt.startWhenConverged=false; % [logical]: Trigger local optimization when population appears converged.
par.localOpt.POptimizeOnImprovement=0; % [0 - 1]: Probability of optimization after improvement of best solution.
par.localOpt.POptimizeOnNoImprovement=0; % [0 - 1]: Probability of optimization after no improvement of best solution.
par.localOpt.maxFEval=1000; % [integer]: Maximum number of evaluations allowed for each local optimization.
par.localOpt.tolX=1e-6; % [real > 0, usually small]: Tolerance in X for local optimization.
par.localOpt.tolF=1e-6; % [real > 0, usually small]: Tolerance in F for local optimization.
par.localOpt.frac=0.1; % [0 - 1]: Fraction of optimals to undergo local optimization.  NaN defaults value to a single optimal for
par.localOpt.maxNOptimals=5; % [integer >= 1]: Maximum number of optimals to undergo local optimization.  NaN or Inf
% ====================================
% Interface
par.interface.xAxis.type='F';
par.interface.xAxis.value=1;
par.interface.yAxis.type='F';
par.interface.yAxis.value=2;
par.interface.zAxis.type='X';
par.interface.zAxis.value=1;
