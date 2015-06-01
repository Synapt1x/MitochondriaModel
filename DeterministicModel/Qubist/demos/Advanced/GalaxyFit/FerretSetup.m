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
par.history.NGenPerHistoryFile=25;
% ====================================
% General

% % Disk parameters:
% K.I0=X(1,i); --> logI
% K.Rd=X(2,i);
% %
% % Sersic bulge parameters:
% K.Ie=X(3,i);
% K.Re=X(4,i);
% K.n=X(5,i);

par.general.min=[1, 10, 1, 1, 0.5];
par.general.max=[10, 400, 10,  50, 10];
par.general.popSize=250;
par.general.NGen=100000;
par.general.NPop=1;
% ====================================
% Parallel Computing
par.parallel.NWorkers=0; % Number of worker nodes to launch initially.
par.parallel.nodeDistributionFactor=5;
par.parallel.timeout=10000; % Maximum time in seconds before an unresponsive node disconnects.
par.parallel.useJava=true; % Is Java required for worker nodes?
par.parallel.writeLogFiles=true; % Are log files required?
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=1;
par.selection.FAbsTol=0;
par.selection.exploitFrac=1;
% ====================================
% Niching
par.niching.X=0.25;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0.01;
par.CPD.PReactivateGenes=0.001;
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
par.immigration.PImmigrate=0.01;
% ====================================
% Elitism
par.elitism.frac=0.1; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=0.25;
% ====================================
% Zooming
par.zoom.NGen=25;
par.zoom.safety=0.5;
% ====================================
% Analysis
par.analysis.analyzeWhenDone=false;
% ====================================
% Local Optimization
par.localOpt.startGen=Inf;
par.localOpt.startF=Inf;
par.localOpt.startWhenConverged=false;
par.localOpt.POptimizeOnImprovement=0.05;
par.localOpt.POptimizeOnNoImprovement=0.05;
% ====================================
% Interface
par.interface.myPlot='myPlot';
