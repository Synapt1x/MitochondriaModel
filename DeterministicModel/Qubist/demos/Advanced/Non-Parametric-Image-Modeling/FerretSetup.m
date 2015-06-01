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
NTerms=numel(par.user.extPar.img);
par.general.min=zeros(1,NTerms);
par.general.max=ones(1,NTerms);
par.general.popSize=100;
par.general.NGen=100000;
par.general.NPop=1;
% ====================================
% Strategy Parameters
par.strategy.isAdaptive=true; % [logical]: Global switch for strategy adaptation.
par.strategy.NGen=25; % [integer > 1]: Number of generations over which trackers are smoothed and forget their history.
%
% Which strategy parameters are allowed to adapt? (true or false)
par.strategy.adapt.mutation.scale=true; % [logical]
par.strategy.adapt.XOver.dispersion=true; % [logical]
par.strategy.adapt.XOver.strength=true; % [logical]
par.strategy.adapt.XOver.ALS=true; % [logical]
par.strategy.adapt.XOver.matingRestriction=true; % [logical]
par.strategy.adapt.niching.acceleration=false; % [logical]
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
par.selection.FAbsTol=0;
par.selection.exploitFrac=0.5;
% ====================================
% Niching
par.niching.X=0.25;
%
% !!!!! TURN OFF NICHING ACCELERATION - MUCH TOO EXPENSIVE FOR LARGE
% NON-PARAMETRIC PROBLEMS!
par.niching.acceleration=0;
% ====================================
% Critical Parameter Detection
% par.CPD.PDeactivateGenes=0.001;
% par.CPD.PReactivateGenes=0.01;
% ====================================
% Mutation
par.mutation.PMutate=0.1;
par.mutation.PSuperMutate=0.0;
par.mutation.selectiveMutation=-0.5;
%
% !!!!! THIS OPTION EXISTS TO HELP WITH LARGE NON-PARAMETRIC PROBLEMS!
par.mutation.BBRestricted=true;
%
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.matingRestriction.X=-0.5;
par.XOver.PAntiXOver=0.1;
par.XOver.ALS=0;
par.XOver.dispersion=0.25;
% ====================================
% Building Block Crossover
par.XOverBB.PXOver=1; % Probability of Building Block crossovers.
% par.XOverBB.multiBB=1; % Single or multiple BB XOver?
%
% !!!!! THIS OPTION EXISTS TO HELP WITH LARGE NON-PARAMETRIC PROBLEMS!
par.XOver.BBRestricted=true;
%
% ====================================
% Immigration
par.immigration.PImmigrate=0.01;
% ====================================
% Elitism
par.elitism.frac=0.001; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=0;
par.link.initialLinkage=0.5;
% ====================================
% Zooming
par.zoom.NGen=50;
par.zoom.safety=0.5;
% ====================================
% Analysis
par.analysis.analyzeWhenDone=false;
% ====================================
% Local Optimization
par.localOpt.startGen=Inf;
par.localOpt.startF=Inf; %1.25;
par.localOpt.startWhenConverged=false;
par.localOpt.POptimizeOnImprovement=0.05;
par.localOpt.POptimizeOnNoImprovement=0.05;
% ====================================
% Interface
par.interface.myPlot='myPlot';
