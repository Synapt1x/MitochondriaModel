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
par.general.min=zeros(1,30);
par.general.max=1+zeros(1,30);
par.general.discreteStep=[];
par.general.XLabels={};
par.general.FLabels={};
par.general.NPop=5;
par.general.popSize=200;
par.general.NGen=1000;
% ====================================
% Selection
% !!! Selection is driven very strongly in this demo by BB pressure.  The demo should work
% just fine even setting par.selection.PTournament=0 and par.selection.BBpressure=1.
par.selection.PTournament=1;
par.selection.BBpressure=1;
par.selection.FRelTol=0; % [0 - 1]: Fraction of fitness range to use as a fuzzy fitness band.
par.selection.FAbsTol=0; % Absolute fitness range (+/- FAbsTol) to use as a fuzzy fitness band.
par.selection.FRankTol=0; % [0 - 1]: Fraction of rank range to use as a fuzzy fitness band.
% WARNING: The Tol parameters strongly affect linkage learning, since they
% determine whether 2 fitness values are considered far enough apart to
% contribute to a rank difference.
% ====================================
% Mutation
par.mutation.PMutate=0.25;
par.mutation.scale=0.25;
% ====================================
% Crossover
par.XOver.PXOver=0;
par.XOver.PAntiXOver=0; 
% ====================================
% Building Block Crossover
%
% !!!!! multiBB=0 IS CRUCIAL FOR BADLY SCALED BB PROBLEMS !!!!!
par.XOverBB.multiBB=0; % Single or multiple BB XOver?
par.XOverBB.PXOver=1; % Probability of Building Block crossovers.
par.XOverBB.NPass=3;
% ====================================
% Niching
par.niching.P=0;
par.niching.X=0;
par.niching.F=0;
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0;
par.CPD.PReactivateGenes=0;
% ====================================
% Immigration
par.immigration.PImmigrate=0.05;
% ====================================
% Elitism
par.elitism.frac=0.1; % # of elite individuals per generation.
% ====================================
% Linkage Learning
par.link.PLink=1; % [0:1]: Probability that an individual will be chosen for linkage learning.
% !!! For a badly scaled problem like this one, it is very important to set the link tolerances
% to zero, or smaller than the smallest building block fitness scale in the problem.par.link.FAbsTol=0; % Absolute fitness range (+/- FAbsTol) to use as a fuzzy fitness band.
par.link.FRelTol=0; % [0 - 1]: Fraction of fitness range to use as a fuzzy fitness band.
% par.link.maxStrongLinkFrac=0.33; % [0:1]
% par.link.NLinkMax=100; % [integer >= 1]: Maximum number of linkage attempts per generation.
par.link.lifetime=100; % [integer >= 1]: Lifetime of linkages.
par.link.useOptimalDonors=0; % [0 or 1]: Should a member of the Optimal set be used for the donor?
par.link.acceleration=2; % [real >= 1]: Accelerate decay of weak links.
par.link.failureCost=1; % [real ~1]: Cost associated with higher-order links.
par.link.initialLinkage=0.5; % [0:1]: How linked are the parameters initially?
par.link.maxPass=20; % [integer >= 1]: Max number of passes through the linkage queue.
par.link.searchThreshold=1; % [0:1]: Stop looking for linkages when links are stronger than this value.
par.link.PMultiLink=0; % [0:1]: Linkage strategy.  0 --> simple links only.  1 --> general, higher order links possible.
par.link.strategy=1; % [0:1]: 0 --> opportunistic, 1 --> aggressive.
par.link.PRandomizeNewBBs=0;  % [0:1]: Randomize BBs when they form?
par.link.mixDim=0.5; % [usually 0:1, possibly higher]: Greater than 0 if mixing is desired.
%
% !!! BUILDING BLOCK RESTRICTION HERE !!!
par.link.restrict=[7:15, 22:28]; % Test building block restrictions.
%
par.link.BB={}; % [linkage matrix (0-1), or cell array of integer vectors]: Known building blocks. Empty list if none are known.
% ====================================
% Graphics & messages
par.interface.graphics=1;
par.interface.myPlot='';
par.interface.titleFontSize=16;
par.interface.labelFontSize=14;
par.interface.axisFontSize=12;
par.interface.xAxis.type='X';
par.interface.xAxis.value=1;
par.interface.yAxis.type='F';
par.interface.yAxis.value=1;
