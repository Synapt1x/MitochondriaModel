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
par.user.output='output';
% ====================================
% Data
par.history.NGenPerHistoryFile=5;
% ====================================
% General
n=par.user.extPar.n;
par.general.min=-2.12+zeros(1,n);
par.general.max=2.12+zeros(1,n);
par.general.popSize=250;
par.general.NGen=100000;
par.general.NPop=1;
% ====================================
% Parallel Computing
par.parallel.NWorkers=0; % Number of worker nodes to launch initially.
par.parallel.timeout=10000; % Maximum time in seconds before an unresponsive node disconnects.
par.parallel.useJava=true; % Is Java required for worker nodes?
par.parallel.writeLogFiles=true; % Are log files required?
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=1;
par.selection.exploitFrac=0.25;
par.selection.FRankTol=0.2;
% par.selection.FRelTol=0.25;
% ====================================
% Niching
% !!!!! NOTE THE HIGH VALUE OF par.niching.acceleration. !!!!!
% This helps Ferret to explore long slender valleys, which make
% problems like this one difficult.
par.niching.X=0.3;
par.niching.acceleration=5;
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
par.XOver.PAntiXOver=0.5;
par.XOver.ALS=0.1;
par.XOver.dispersion=0.1;
par.XOver.maxScale=3;
% ====================================
% Building Block Crossover
par.XOverBB.PXOver=1; % Probability of Building Block crossovers.
% ====================================
% Immigration
par.immigration.PImmigrate=0.01;
% ====================================
% Elitism
par.elitism.frac=0.1; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=1;
% ====================================
% Zooming
par.zoom.NGen=25;
par.zoom.safety=0.25;
% ====================================
% Analysis
par.analysis.analyzeWhenDone=false;
% ====================================
% Local Optimization
par.localOpt.startGen=100;
par.localOpt.startF=Inf; %1.25;
par.localOpt.startWhenConverged=true;
par.localOpt.POptimizeOnImprovement=0.05;
par.localOpt.POptimizeOnNoImprovement=0.05;
% ====================================
% Interface
par.interface.myPlot='myPlot';