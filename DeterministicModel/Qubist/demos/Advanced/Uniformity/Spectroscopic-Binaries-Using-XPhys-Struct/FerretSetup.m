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

% ====================================
% User
par.user.fitnessFcn='binaryFitness';
%
% ====================================
% History
par.history.NGenPerHistoryFile=25; % [integer >= 1]: How many generations per History file?
par.history.saveFrac=0; % [0 - 1]: Save only the optimals --> [0], or a fraction [0 - 1].
%
% ====================================
% General
par.general.XLabels={'\phi', 'sin i', 'eccentricity', 'log_{10}(mass_1)', 'log_{10}(mass_2)', 'log_{10}(a)'};
par.general.range.phi=[0, 360];
par.general.range.sini=[0,1];
par.general.range.e=[0, 0.9];
par.general.range.log_m1=[-1,1];
par.general.range.log_m2=[-1,1];
par.general.range.log_a=[-1,1];

par.general.NPop=2;
par.general.popSize=250;
par.general.NGen=10000;
%
% ====================================
% Selection
par.selection.PTournament=1; % [0 - 1]: Natural selection: probability that each individual will compete.
par.selection.pressure=1; % [0 - 1]: Natural selection pressure on overall fitness.
par.selection.BBPressure=1; % [0 - 1]: Selection pressure on BBs.
par.selection.FAbsTol=1; % Absolute fitness range (+/- FAbsTol) to use as a fuzzy fitness band.
par.selection.FRelTol=0; % [0 - 1]: Fraction of fitness range to use as a fuzzy fitness band.
% par.selection.clusterScale=1;%
% !!! N.B. !!!
% par.selection.exploitFrac=0; % !!! Useful for a mapping problem like this one !!!
%
% ====================================
% Niching
par.niching.X=0.3;
%
% ====================================
% Critical Parameter Detection
par.CPD.PDeactivateGenes=0; % [0:1]: Probability of gene deactivation.
par.CPD.PReactivateGenes=0; % [0:1]: Probability of gene reactivation.
par.CPD.NaN2Random=1; %  [0 or 1, usually 1]: Replace undefined genes (NaN's) with random numbers?
par.CPD.minimizeGenomeSize=1; % [0 or 1, usually 1]: Search for minimal genomes?
%
% ====================================
% Mutation
par.mutation.PMutate=0.1; % [0 - 1]: Probability of mutation.
par.mutation.PSuperMutate=0.01; % [0 - 1]: Probability of superMutation.
par.mutation.scale=0.25; % [0 - 1]: Min & max scale of mutation.
par.mutation.selectiveMutation=-1; % [-1:1]: Negative values mutate highly clustered individuals selectively.
%
% ====================================
% Crossover
par.XOver.PXOver=1;  % [0:1]: Probability of X-Type crossovers.
% par.XOver.strength=0.025; % [0 - 1]: Scale of crossover.
% par.XOver.PAntiXOver=0.2; % [0:1]: Probability of anti-crossovers.
% par.XOver.matingRestriction.X=-0;
%
% ====================================
% Elitism
par.elitism.frac=0.1; % # of elite individuals per generation.  Probably not useful for multi-objective problems.
%
% ====================================
% Zooming
par.zoom.NGen=40; % [integer >= 1]: Zoom control.
par.zoom.safety=0.5; % [real, usually <= 1]: Size of buffer zone around optimal set.
par.zoom.allowZoomOut=true; % [logical]: Is zoom-out permitted?
%
% ====================================
% Immigration
par.immigration.PImmigrate=0.01;
%
% ====================================
% Verbosity & Graphics
par.interface.verbose=1;
par.interface.graphics=1;
par.interface.myPlotFunction='myPlot';

% ====================================
% Etc
par.zoom.NGen=40;
% par.selection.clusterScale=0.2;
par.link.FAbsTol=1e-3; % Absolute fitness range (+/- FAbsTol) to use as a fuzzy fitness band.
par.link.FRelTol=1e-3; % [0 - 1]: Fraction of fitness range to use as a fuzzy fitness band.
par.link.PLink=1;
par.parallel.timeout=10;
par.parallel.nodeDistributionFactor=2;
