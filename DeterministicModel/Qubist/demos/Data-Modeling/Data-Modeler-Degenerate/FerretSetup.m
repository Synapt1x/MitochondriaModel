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
% Helper function.  FerretSetup needs to know the number of terms.
NTerms=getNTerms;
% ====================================
% User
par.user.fitnessFcn='fitness';
% ====================================
% Data
par.history.NGenPerHistoryFile=25;
par.history.saveFrac=0.5;
% ====================================
% General
par.general.min=zeros(1,2*NTerms);
par.general.max=[ones(1,NTerms),2*pi*ones(1,NTerms)];
par.general.cyclic=NTerms+1:2*NTerms;
par.general.popSize=100;
par.general.NGen=100000;
par.general.NPop=1;
% ====================================
% Selection
par.selection.PTournament=1;
par.selection.pressure=0.75;
par.selection.BBPressure=0.1;
par.selection.FAbsTol=1;
par.selection.FRankTol=0;
% ====================================
% Niching
par.niching.mergeMetric='combine'; % [string: 'combine' (default) or 'Pareto']: Method to combine niching in P, X, and F spaces.
par.niching.P=0;  % [0:1]: Pattern niching: Typically ~0.5 is about right.
par.niching.X=0.3;  % [0:1]: X-Niching: Typically ~0.25 is about right.
par.niching.F=0;  % [0:1]: F-Niching: Typically ~0.25 is about right.
par.niching.method='sigmaShare'; % [string: 'sigmaShare' or 'powerLaw']: Specify a niching method.
par.niching.exponent=2; % [real: usually > 0 & <~ 2]: Used in the niche function.
par.niching.powers=2; % [real vector: usually > 0]: Used only for power-law niching - not sigmaShare. 
par.niching.acceleration=0.5; % [0:1]: Acceleration parameter.
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0.001;
par.CPD.PReactivateGenes=0.01;
% ====================================
% Mutation
par.mutation.PMutate=0.1;
par.mutation.PSuperMutate=0.1;
par.mutation.selectiveMutation=-1;
par.mutation.scale=0.25;
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
par.XOver.PAntiXOver=0.1;
par.XOver.ALS=1;
par.XOver.matingRestriction.X=0;
% ====================================
% Building Block Crossover
par.XOverBB.PXOver=1; % Probability of Building Block crossovers.
par.XOverBB.NPass=1;
% ====================================
% Immigration
par.immigration.PImmigrate=0.01;
% ====================================
% Elitism
par.elitism.frac=0.3; % Fraction of population that are elite.
% ====================================
% Linkage Learning
par.link.PLink=0.25;
par.link.initialLinkage=0.5;
par.link.PRandomizeNewBBs=0;
% ====================================
% Zooming
par.zoom.NGen=25;
par.zoom.safety=0.5;
% ====================================
% Local Optimization
par.localOpt.startGen=Inf;
par.localOpt.POptimizeOnImprovement=1;
par.localOpt.POptimizeOnNoImprovement=1;
par.localOpt.maxFEval=100;
par.localOpt.tolX=1e-6;
par.localOpt.tolF=1e-6;
% ====================================
% Interface
par.interface.myPlot='myPlot';
