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
% General
%
% K.rOut=X(1);
% K.rIn=X(2);
% K.rho0=X(3);
% K.drho_dr=X(4);
% K.sigma=X(5);
%
K0=defaultPar;
par.general.min=[1,0.1,0.5,-1];
par.general.max=[K0.rMax,K0.rMax/2,5,1];
par.general.popSize=100;
par.general.NGen=100000;
par.general.NPop=2;
% ====================================
% Parallel Computing
% par.parallel.NWorkers=2; % Number of worker nodes to launch initially.
par.parallel.nodeDistributionFactor=1;
par.parallel.timeout=10; % Maximum time in seconds before an unresponsive node disconnects.
par.parallel.useJava=true; % Is Java required for worker nodes?
par.parallel.writeLogFiles=true; % Are log files required?
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=0.9;
par.selection.FAbsTol=1;
par.selection.exploitFrac=0.1;
% par.selection.clusterScale=0.5;
% ====================================
% Niching
par.niching.X=0.25;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0;
par.CPD.PReactivateGenes=0;
% ====================================
% Mutation
par.mutation.PMutate=0.1;
par.mutation.PSuperMutate=0.01;
par.mutation.selectiveMutation=-0.5;
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.matingRestriction.X=-0.5;
par.XOver.PAntiXOver=0.1;
par.XOver.ALS=0.1;
par.XOver.dispersion=0.25;
% ====================================
% Building Block Crossover
par.XOverBB.PXOver=1; % Probability of Building Block crossovers.
% ====================================
% Immigration
par.immigration.PImmigrate=0.02;
% ====================================
% Elitism
par.elitism.frac=0.1; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=1; % 0.25;
par.link.PMultiLink=0;
% ====================================
% Zooming
par.zoom.NGen=10;
par.zoom.safety=0.5;
% ====================================
% Analysis
par.analysis.analyzeWhenDone=false;
% ====================================
% Local Optimization
par.localOpt.startGen=Inf;
par.localOpt.startF=Inf;
par.localOpt.maxNMoves=100;
par.localOpt.startWhenConverged=false;
par.localOpt.POptimizeOnImprovement=0.025;
par.localOpt.POptimizeOnNoImprovement=0.025;
% ====================================
% Interface
par.interface.myPlot='myPlot';

par.polish.optimizer='fminsearch';
% par.polish.optimizer='SAMOSA';
% par.polish.optimizer='Anvil';
% par.polish.optimizer='SemiGloSS';
% par.polish.optimizer='default'; % [string]: Use defaults.
