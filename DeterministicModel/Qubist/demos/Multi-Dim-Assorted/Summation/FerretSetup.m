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
N=par.user.extPar.N;
% ====================================
% User
par.user.fitnessFcn='fitness';
% ====================================
% Data
% ====================================
% General
par.general.min=-ones(1,N);
par.general.max=ones(1,N);
par.general.NPop=1;
par.general.popSize=250;
par.general.NGen=1000;
% ====================================
% Selection
par.selection.PTournament=1;
% ====================================
% Mutation
par.mutation.PMutate=0.05;
par.mutation.scale=0.25;
par.mutation.selectiveMutation=-1;
% ====================================
% Crossover
par.XOver.PXOver=1;  % Cross-over probability
% ====================================
% Building Block Crossover
par.XOverBB.PXOver=1; % [0 - 1]: Probability of Building Block crossovers.
par.XOverBB.NPass=1; % [integer >= 0]: Number of passes through BB selection per cycle.
% ====================================
% Linkage Learning
par.link.PLink=0; % [0 - 1]: Probability that an individual will be chosen for linkage learning.
par.link.FAbsTol=1e-6; % Absolute fitness range (+/- FAbsTol) to use as a fuzzy fitness band.
par.link.FRelTol=1e-6; % [0 - 1]: Fraction of fitness range to use as a fuzzy fitness band.
par.link.maxStrongLinkFrac=1; % [0 - 1]
par.link.NLinkMax=Inf; % [integer >= 1]: Maximum number of linkage attempts per generation.
par.link.lifetime=100; % [integer >= 1]: Lifetime of linkages.
par.link.useOptimalDonors=false; % [logical]: Should a member of the Optimal set be used for the donor?
par.link.acceleration=2; % [real >= 1]: Accelerate decay of weak links.
par.link.failureCost=1; % [real ~1]: Cost associated with higher-order links.
par.link.initialLinkage=0.5; % [0 - 1]: How linked are the parameters initially?
par.link.maxPass=20; % [integer >= 1]: Max number of passes through the linkage queue.
par.link.searchThreshold=0.9; % [0 - 1]: Stop looking for linkages when links are stronger than this value.
par.link.PMultiLink=0.5; % [0 - 1]: Linkage strategy.  0 --> simple links only.  1 --> general, higher order links possible.
par.link.strategy=0.5; % [0 - 1]: 0 --> opportunistic, 1 --> aggressive.
par.link.PRandomizeNewBBs=0;  % [0 - 1]: Randomize BBs when they form?
par.link.mixDim=0; % [usually 0 - 1, possibly higher]: Greater than 0 if mixing is desired.
par.link.restrict=[]; % [integer vector > 1]: List of genes allowed to link.  Empty vector --> all allowed.
par.link.BB={}; % [linkage matrix (0-1), or cell array of integer vectors]: Known building blocks. Empty list if none are known.
% ====================================
% Niching
par.niching.X=0.25;
% ====================================
% Zooming
par.zoom.NGen=Inf;
par.zoom.safety=0.25;
par.zoom.allowZoomOut=1;
% ====================================
% Elitism
par.elitism.frac=0.05; % Fraction of population that are elite.
% ====================================
% Graphics & messages
par.interface.myPlot='myPlot';
